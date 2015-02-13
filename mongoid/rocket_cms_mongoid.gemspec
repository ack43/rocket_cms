lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rocket_cms/version'

Gem::Specification.new do |spec|
  spec.name          = 'ack_rocket_cms_mongoid'
  spec.version       = RocketCMS::VERSION
  spec.authors       = ['glebtv', 'Alexander Kiseliev']
  spec.email         = ['glebtv@gmail.com', "i43ack@gmail.com"]
  spec.description   = %q{RocketCMS fork - Mongoid metapackage}
  spec.summary       = %q{}
  spec.homepage      = 'https://github.com/ack43/rocket_cms'
  spec.license       = 'MIT'

  spec.files         = %w(lib/ack_rocket_cms_mongoid.rb)
  spec.executables   = []
  spec.test_files    = []
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  
  spec.add_dependency 'mongoid', '~> 4.0.0'
  spec.add_dependency 'ack_rocket_cms', RocketCMS::VERSION

  spec.add_dependency 'glebtv-mongoid_nested_set'
  spec.add_dependency 'glebtv-mongoid-paperclip'
  spec.add_dependency 'mongoid-audit', '~> 1.0.0'
  spec.add_dependency 'mongoid-slug'

  spec.add_dependency 'mongo_session_store-rails4'
  spec.add_dependency 'rails_admin_settings', '~> 0.9.0'
end

