module RocketCMS
  class << self
    def map_config(is_active = true)
      Proc.new {
        active is_active
        label I18n.t('rs.map')
        field :address, :string
        field :map_address, :string
        field :map_hint, :string
        field :coordinates, :string do
          read_only true
          formatted_value{ bindings[:object].coordinates.to_json }
        end
        field :lat
        field :lon
      }
    end
    
    def seo_config(is_active = false)
      Proc.new {
        active is_active
        label "SEO"
        field :h1, :string
        field :title, :string
        field :keywords, :text
        field :description, :text
        field :robots, :string

        field :og_title, :string
        field :og_image
      }
    end
    
    def page_config
      Proc.new {
        RocketCMS.apply_patches self
        navigation_label I18n.t('rs.cms')
        list do
          scopes [:sorted, :enabled, nil]

          field :enabled,  :toggle
          field :menus, :menu
          field :name
          field :fullpath do
            pretty_value do
              bindings[:view].content_tag(:a, bindings[:object].fullpath, href: bindings[:object].fullpath)
            end
          end
          field :redirect
          field :slug
          RocketCMS.apply_patches self
        end
        edit do
          field :name
          field :excerpt, :ck_editor
          field :content, :ck_editor
          RocketCMS.apply_patches self
          group :menu do
            label I18n.t('rs.menu')
            field :menus
            field :fullpath, :string do
              help I18n.t('rs.with_final_slash')
            end
            field :regexp, :string do
              help I18n.t('rs.page_url_regex')
            end
            field :redirect, :string do
              help I18n.t('rs.final_in_menu')
            end
            field :text_slug
          end
          group :seo, &RocketCMS.seo_config
          group :sitemap_data, &RocketCMS.sitemap_data_config
        end
        RocketCMS.only_patches self, [:show, :export]
        nested_set({
          max_depth: RocketCMS.configuration.menu_max_depth
        })
      }
    end
    
    def menu_config
      Proc.new {
          navigation_label 'CMS'

          field :enabled, :toggle
          field :text_slug
          field :name
          RocketCMS.apply_patches self
          RocketCMS.only_patches self, [:show, :list, :edit, :export]
      }
    end
    
    def contact_message_config
      Proc.new {
        navigation_label I18n.t('rs.settings')
        field :created_at do
          read_only true
        end
        field :name
        field :content, :text
        field :email
        field :phone

        RocketCMS.apply_patches self
        RocketCMS.only_patches self, [:show, :list, :edit, :export]
      }
    end

    def news_config
      Proc.new {
        navigation_label I18n.t('rs.cms')
        list do
          scopes [:by_date, :enabled, nil]
        end

        field :enabled, :toggle
        field :time
        field :name
        unless RocketCMS.configuration.news_image_styles.nil?
          field :image
        end
        field :excerpt
        RocketCMS.apply_patches self

        edit do
          field :content, :ck_editor
          RocketCMS.apply_patches self
          group :seo, &RocketCMS.seo_config
          group :sitemap_data, &RocketCMS.sitemap_data_config
        end

        RocketCMS.only_patches self, [:show, :list, :export]
      }
    end

    def sitemap_data_config(is_active = false)
      Proc.new {
        active is_active
        label I18n.t('rs.sitemap_data')
        field :sitemap_show
        field :sitemap_lastmod
        field :sitemap_changefreq, :enum do
          enum do
            SitemapData::SITEMAP_CHANGEFREQ_ARRAY
          end
        end
        field :sitemap_priority
      }
    end
  end
end
