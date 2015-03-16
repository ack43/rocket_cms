module RocketCMS
  module Models
    module EmbeddedGalleryImage
      extend ActiveSupport::Concern
      include RocketCMS::Model
      include Enableable
      include Sortable
      include RocketCMS.orm_specific('EmbeddedGalleryImage')
    end
  end
end