module RocketCMS
  module Models
    module Gallery
      extend ActiveSupport::Concern
      include RocketCMS::Model
      include Enableable
      include ManualSlug
      include SitemapData
      include RocketCMS.orm_specific('Gallery')

      included do
        has_many :gallery_images
        field :name, type: String, localize: RocketCMS.configuration.localize
      end
    end
  end
end