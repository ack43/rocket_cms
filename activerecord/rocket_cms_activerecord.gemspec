lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rocket_cms/version'

Gem::Specification.new do |spec|
  spec.name          = 'ack_rocket_cms_activerecord'
  spec.version       = RocketCMS::VERSION
  spec.authors       = ['glebtv', 'Alexander Kiseliev']
  spec.email         = ['glebtv@gmail.com', "i43ack@gmail.com"]
  spec.description   = %q{RocketCMS fork - ActiveRecord metapackage}
  spec.summary       = %q{}
  spec.homepage      = 'https://github.com/ack43/rocket_cms'
  spec.license       = 'MIT'

  spec.files         = %w(lib/ack_rocket_cms_activerecord.rb)
  spec.executables   = []
  spec.test_files    = []
  spec.require_paths = ['lib']
  
  spec.add_dependency 'ack_rocket_cms', RocketCMS::VERSION
  spec.add_dependency 'awesome_nested_set'
  spec.add_dependency 'paperclip'
  spec.add_dependency 'paper_trail'
  spec.add_dependency 'friendly_id', '~> 5.1.0.beta.1'
  spec.add_dependency "validates_lengths_from_database"
  spec.add_dependency 'foreigner'
  spec.add_dependency 'pg_search'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end

