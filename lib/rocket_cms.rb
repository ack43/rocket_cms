unless defined?(RocketCMS) && [:active_record, :mongoid].include?(RocketCMS.orm)
  puts "please use rocket_cms_mongoid or rocket_cms_activerecord and not rocket_cms directly"
  exit 1
end

require 'rocket_cms/version'
require 'devise'
require 'simple_form'
require 'glebtv-simple_captcha'
require 'validates_email_format_of'
require 'smart_excerpt'
require 'filename_to_slug'
require 'rails_admin'
require 'rails_admin_nested_set'
require 'rails_admin_toggleable'
require 'rails_admin_settings'

require 'mongoid-audit'
# require 'history_tracker'

require 'mongoid_slug'

require 'x-real-ip'

require 'glebtv-ckeditor'

require 'sitemap_generator'
require 'kaminari'
require 'addressable/uri'
require 'turbolinks'
require 'simple-navigation'

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

  module Models
    autoload :Menu, 'rocket_cms/models/menu'
    autoload :Page, 'rocket_cms/models/page'
    autoload :News, 'rocket_cms/models/news'
    autoload :ContactMessage, 'rocket_cms/models/contact_message'

    module Mongoid
      autoload :Menu, 'rocket_cms/models/mongoid/menu'
      autoload :Page, 'rocket_cms/models/mongoid/page'
      autoload :News, 'rocket_cms/models/mongoid/news'
      autoload :ContactMessage, 'rocket_cms/models/mongoid/contact_message'
    end

    module ActiveRecord
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