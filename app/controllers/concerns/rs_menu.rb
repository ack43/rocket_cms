module RsMenu
  extend ActiveSupport::Concern
  included do
    helper_method :navigation
  end

  def render_with_subs(items, primary, item)
    subs = items.select { |i| i.parent_id == item.id && !i.name.blank? && i.enabled }
    if subs.empty?
      block = nil
    else
      block = Proc.new do |sub_nav|
        subs.each { |sub| render_with_subs(items, sub_nav, sub) }
      end
    end
    cr = item.clean_regexp
    navigation_item(primary, item, block)
  end
  
  def navigation_item(primary, item, block=nil)
    url = item.redirect.blank? ? item.fullpath : item.redirect
    if block.nil?
      primary.item(item.slug, item.name, url, item.nav_options)
    else
      primary.item(item.slug, item.name, url, item.nav_options, &block)
    end
  end

  def navigation(type)
    Proc.new do |primary|
      SimpleNavigation.config.autogenerate_item_ids = false
      begin
        items = ::Menu.find(type.to_s).pages.asc(:lft).to_a
        items.select { |i| i.parent_id.nil? && !i.name.blank? && i.enabled }.each do |item|
          render_with_subs(items, primary, item) if primary
        end
      rescue Exception => exception
        Rails.logger.error exception.message
        Rails.logger.error exception.backtrace.join("\n")
        capture_exception(exception) if respond_to?(:capture_exception)
        items
      end
    end
  end
end
