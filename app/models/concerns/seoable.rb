module Seoable
  extend ActiveSupport::Concern
  include Mongoid::Paperclip
  
  included do
    field :name,        type: String, localize: true
    field :h1,          type: String, localize: true

    field :title,       type: String, localize: true
    field :keywords,    type: String, localize: true
    field :description, type: String, localize: true
    field :robots,      type: String, localize: true

    field :og_title,    type: String, localize: true
    has_mongoid_attached_file :og_image, styles: {thumb: "800x600>"}
  end

  def page_title
    title.blank? ? name : title
  end

  def get_og_title
    og_title.blank? ? name : og_title
  end
  
  def self.admin
    RocketCMS.seo_config
  end
  
  # deprecated
  def self.seo_config
    RocketCMS.seo_config
  end
end

