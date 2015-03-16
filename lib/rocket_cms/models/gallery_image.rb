module RocketCMS
  module Models
    module GalleryImage
      extend ActiveSupport::Concern
      include RocketCMS::Model
      include Enableable
      include RocketCMS.orm_specific('GalleryImage')

      included do
        belongs_to :gallery
        field :name, type: String
      end
    end
  end
end