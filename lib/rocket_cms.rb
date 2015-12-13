unless defined?(RocketCMS) && RocketCMS.respond_to?(:orm) && [:active_record, :mongoid].include?(RocketCMS.orm)
  puts "please use ack_rocket_cms_mongoid or ack_rocket_cms_activerecord and not ack_rocket_cms directly"
  exit 1
end

require 'rocket_cms/version'
require 'devise'

require 'simple_form'
require 'rocket_cms/simple_form_patch'

require 'glebtv-simple_captcha'
require 'validates_email_format_of'
require 'smart_excerpt'
require 'filename_to_slug'
require 'rails_admin'
require 'rails_admin_nested_set'
require 'rails_admin_toggleable'
# require 'rails_admin_settings'

require 'x-real-ip'

require 'ckeditor'

require 'sitemap_generator'
require 'kaminari'
require 'addressable/uri'
require 'turbolinks'
require 'simple-navigation'
require 'ack_rails_admin_jcrop'

require 'rocket_cms/seo_helpers'
require 'rocket_cms/configuration'
require 'rocket_cms/patch'
require 'rocket_cms/admin'
require 'rocket_cms/elastic_search'
require 'rocket_cms/model'
require 'rocket_cms/rails_admin_menu'
require 'rocket_cms/engine'
require 'rocket_cms/controller'

module RocketCMS
  class << self
    def mongoid?
      RocketCMS.orm == :mongoid
    end
    def active_record?
      RocketCMS.orm == :active_record
    end
    def model_namespace
      "RocketCMS::Models::#{RocketCMS.orm.to_s.camelize}"
    end
    def orm_specific(name)
      "#{model_namespace}::#{name}".constantize
    end
  end

  autoload :Migration, 'rocket_cms/migration'

  # module Mongoid
  #   autoload :Paperclip  'rocket_cms/mongoid/paperlcip'
  # end

  module Models
    autoload :Seo,  'rocket_cms/models/seo'
    autoload :Menu, 'rocket_cms/models/menu'
    autoload :Page, 'rocket_cms/models/page'
    autoload :News, 'rocket_cms/models/news'
    autoload :ContactMessage, 'rocket_cms/models/contact_message'

    autoload :EmbeddedElement,      'rocket_cms/models/embedded_element'

    autoload :EmbeddedGalleryImage, 'rocket_cms/models/embedded_gallery_image'
    autoload :GalleryImage,         'rocket_cms/models/gallery_image'
    autoload :Gallery,              'rocket_cms/models/gallery'

    module Mongoid
      autoload :Seo,  'rocket_cms/models/mongoid/seo'
      autoload :Menu, 'rocket_cms/models/mongoid/menu'
      autoload :Page, 'rocket_cms/models/mongoid/page'
      autoload :News, 'rocket_cms/models/mongoid/news'
      autoload :ContactMessage, 'rocket_cms/models/mongoid/contact_message'

      autoload :EmbeddedElement,      'rocket_cms/models/mongoid/embedded_element'

      autoload :EmbeddedGalleryImage, 'rocket_cms/models/mongoid/embedded_gallery_image'
      autoload :GalleryImage,         'rocket_cms/models/mongoid/gallery_image'
      autoload :Gallery,              'rocket_cms/models/mongoid/gallery'
    end

    module ActiveRecord
      autoload :Seo,  'rocket_cms/models/active_record/seo'
      autoload :Menu, 'rocket_cms/models/active_record/menu'
      autoload :Page, 'rocket_cms/models/active_record/page'
      autoload :News, 'rocket_cms/models/active_record/news'
      autoload :ContactMessage, 'rocket_cms/models/active_record/contact_message'
    end
  end

  module Controllers
    autoload :Contacts, 'rocket_cms/controllers/contacts'
    autoload :News, 'rocket_cms/controllers/news'
    autoload :Pages, 'rocket_cms/controllers/pages'
    autoload :Search, 'rocket_cms/controllers/search'
  end
end

require 'manual_slug'
