lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rocket_cms/version'

Gem::Specification.new do |spec|
  spec.name          = 'ack_rocket_cms'
  spec.version       = RocketCMS::VERSION
  spec.authors       = ['Alexander Kiseliev', 'glebtv']
  spec.email         = ["i43ack@gmail.com", 'glebtv@gmail.com']
  spec.description   = %q{RocketCMS fork}
  spec.summary       = %q{Please DO NOT use this gem directly, use ack_rocket_cms_mongoid or ack_rocket_cms_activerecord instead!}
  spec.homepage      = 'https://github.com/ack43/rocket_cms'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/).reject {|f| f.start_with?('mongoid') || f.start_with?('activerecord') }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  
  spec.add_dependency 'rails', '>= 4.1.0', '< 5.0'

  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'simple_form'
  spec.add_dependency 'glebtv-simple_captcha'
  spec.add_dependency 'coffee-rails'
  spec.add_dependency 'devise'
  spec.add_dependency 'turbolinks'
  spec.add_dependency 'validates_email_format_of'
  spec.add_dependency 'rails_admin'
  spec.add_dependency 'rails_admin_nested_set'
  spec.add_dependency 'rails_admin_toggleable'

  spec.add_dependency 'ckeditor'
  spec.add_dependency 'rails_admin_settings'

  spec.add_dependency 'geocoder'
  spec.add_dependency 'simple-navigation'
  spec.add_dependency 'sitemap_generator'
  spec.add_dependency 'kaminari'
  spec.add_dependency 'addressable'

  # spec.add_dependency ''
  spec.add_dependency 'x-real-ip'


  spec.add_dependency "rails_admin_mongoid_localize_field", "~> 0.1.2"
  spec.add_dependency "ack_rails_admin_jcrop"

  spec.add_dependency 'stringex'
  spec.add_dependency 'thor'
  spec.add_dependency 'smart_excerpt'
end

