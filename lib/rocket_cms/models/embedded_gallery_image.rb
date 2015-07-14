module RocketCMS
  module Models
    module EmbeddedGalleryImage
      extend ActiveSupport::Concern
      include RocketCMS::Model
      include Enableable
      include Sortable
      include RocketCMS.orm_specific('EmbeddedGalleryImage')

      included do
        validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/, if: :image?
      end
    end
  end
end