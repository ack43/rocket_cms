if RocketCMS.mongoid?
  class Gallery
    include RocketCMS::Models::Gallery
    RocketCMS.apply_patches self

    rails_admin &RocketCMS.gallery_config
  end
end