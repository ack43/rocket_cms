module RocketCMS
  module Models
    module GalleryImage
      extend ActiveSupport::Concern
      include RocketCMS::Model
      include Enableable
      include RocketCMS.orm_specific('GalleryImage')

      included do
        belongs_to :gallery
        field :name, type: String, localize: RocketCMS.configuration.localize

        validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, if: :image?
      end
    end
  end
end