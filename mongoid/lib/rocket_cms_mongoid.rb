require 'mongoid'
require 'glebtv-mongoid-paperclip'
require 'glebtv-mongoid_nested_set'
require 'mongoid-audit'
require 'mongoid_slug'
require 'rocket_cms_mongoid/manual_slug'

module RocketCMS
  def self.orm
    :mongoid
  end
end

require 'rocket_cms'

