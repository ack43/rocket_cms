module RocketCMS
  module Models
    module Mongoid
      module EmbeddedGalleryImage
        extend ActiveSupport::Concern
        include ::Mongoid::Paperclip

        included do
          #embedded_in :model # need to override

          include EmbeddedElement

          has_mongoid_attached_file :image # need to override
          validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

          def image_file_name=(val)
            val = val.to_s
            return if val.blank?
            extension = File.extname(val)[1..-1]
            file_name = val[0..val.size-extension.size-1]
            self[:image_file_name] = "#{file_name.filename_to_slug}.#{extension.filename_to_slug}"
          end
        end
      end
    end
  end
end