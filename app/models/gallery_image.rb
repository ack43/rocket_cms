if RocketCMS.mongoid?
  class GalleryImage
    include RocketCMS::Models::GalleryImage
    RocketCMS.apply_patches self

    rails_admin &RocketCMS.image_config
  end
end