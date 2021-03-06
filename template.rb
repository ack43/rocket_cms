rails_spec = (Gem.loaded_specs["railties"] || Gem.loaded_specs["rails"])
version = rails_spec.version.to_s

mongoid = options[:skip_active_record]

if Gem::Version.new(version) < Gem::Version.new('4.2.4')
  puts "You are using an old version of Rails (#{version})"
  puts "Please update"
  puts "Stopping"
  exit 1
end

remove_file 'Gemfile'
create_file 'Gemfile' do <<-TEXT
source 'https://rubygems.org'

gem 'rails', '4.2.4'
#{if mongoid then "gem 'mongoid', '~> 4.0.0'" else "gem 'pg'" end}

# gem 'sass'
gem 'compass'

#{if mongoid then "gem 'ack_rocket_cms_mongoid'" else "gem 'ack_rocket_cms_activerecord'" end}, '~> 0.8.0'

gem 'devise'

gem 'sass-rails', '~> 5.0'
gem 'compass-rails', '~> 2.0.4'

gem 'slim-rails'
gem 'rs_russian'
gem 'cancancan'

gem 'cloner'
gem 'unicorn'
gem 'x-real-ip'

gem 'sentry-raven'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'spring'

  gem 'capistrano', '~> 3.4.0', require: false

  gem 'rvm1-capistrano3', require: false
  gem 'glebtv-capistrano-unicorn', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false

  gem 'hipchat'
  # gem 'coffee-rails-source-maps'
  # gem 'compass-rails-source-maps'

  gem 'favicon_maker', '0.3'
  gem 'favicon_maker_rails'

  gem 'rails_email_preview', '~> 0.2.29'
end

group :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'email_spec'
  #{if mongoid then "gem 'mongoid-rspec'" else "" end}
  gem 'ffaker'
  gem 'factory_girl_rails'
end

#{if mongoid then "gem 'mongo_session_store-rails4'" else "" end}

gem 'slim'
gem 'sprockets'


gem 'sitemap_generator'
gem 'rails_admin_sitemap'

gem 'uglifier'

group :production do
  gem "god"
end

TEXT
end

remove_file '.gitignore'
create_file '.gitignore' do <<-TEXT
# See https://help.github.com/articles/ignoring-files for more about ignoring files.
#
# If you find yourself ignoring temporary files generated by your text editor
# or operating system, you probably want to add a global ignore instead:
#   git config --global core.excludesfile '~/.gitignore_global'
.idea
.idea/*

/.bundle
/log/*.log
/tmp/*
/public/assets
/public/ckeditor_assets
TEXT
end

create_file 'extra/.gitkeep', ''

if mongoid
remove_file 'config/initializers/embedded_findable.rb'
create_file 'config/initializers/embedded_findable.rb' do  <<-TEXT
module Mongoid

  # Helps to override find method in an embedded document.
  # Usage :
  #   - add to your model "include Mongoid::EmbeddedFindable"
  #   - override find method with:
  #     def self.find(id)
  #       find_through(Book, 'chapter', id)
  #     end
  module EmbeddedFindable

    extend ActiveSupport::Concern

    included do

      # Search an embedded document by id.
      #
      # Document is stored within embedding_class collection, and can be accessed through provided relation.
      # Also supports chained relationships (if the searched document is nested in several embedded documents)
      #
      # Example, with a chapter embedded in a book, the book being embedded in a library.
      # use find_through(Library, "books", book_id) in Book class
      # and find_through(Library, "books.chapters", chapter_id) in Chapter class
      def self.find_through(embedding_class, relation, id = nil)
        return nil if id.nil? || id.blank?

        id = BSON::ObjectId.from_string(id) if id.is_a?(String)
        relation = relation.to_s unless relation.is_a?(String)

        relation_parts = relation.split('.')
        parent = embedding_class.send(:all)

        while relation_parts.length > 0
          item = if parent.is_a?(Mongoid::Criteria) || parent.is_a?(Array)
                   parent.where("\#{relation_parts.join('.')}._id" => id).first
                 else
                   parent
                 end
          return nil if item.nil?
          parent = item.send(relation_parts.shift)
        end

        if parent.is_a?(Mongoid::Criteria) || parent.is_a?(Array)
          parent.where('_id' => id).first
        else
          parent
        end
      end

    end

  end

end
TEXT
end
end

if mongoid
remove_file 'config/initializers/cookies_serializer.rb'
create_file 'config/initializers/cookies_serializer.rb' do  <<-TEXT
# Be sure to restart your server when you modify this file.
# json serializer breaks Devise + Mongoid. DO NOT ENABLE
# See https://github.com/plataformatec/devise/pull/2882
# Rails.application.config.action_dispatch.cookies_serializer = :json
Rails.application.config.action_dispatch.cookies_serializer = :marshal
TEXT
end
end

if mongoid
  remove_file 'config/initializers/session_store.rb'
  create_file 'config/initializers/session_store.rb' do  <<-TEXT
# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_#{app_name.tableize.singularize}_session'
Rails.application.config.session_store :mongoid_store

  TEXT
  end
end

remove_file 'app/controllers/application_controller.rb'
create_file 'app/controllers/application_controller.rb' do <<-TEXT
class ApplicationController < ActionController::Base
  include RocketCMS::Controller
end
TEXT
end

create_file 'config/navigation.rb' do <<-TEXT
# empty file to please simple_navigation, we are not using it
# See https://github.com/ack43/rocket_cms/blob/master/app/controllers/concerns/rs_menu.rb
TEXT
end

create_file 'README.md', "## #{app_name}\nProject generated by RocketCMS\nORM: #{if mongoid then 'Mongoid' else 'ActiveRecord' end}\n\n"

create_file '.ruby-version', "2.2.3\n"
create_file '.ruby-gemset', "#{app_name}\n"

run 'bundle install --without production'

# generate 'rails_email_preview:install'
remove_file 'app/mailer_previews/contact_mailer_preview.rb'
create_file 'app/mailer_previews/contact_mailer_preview.rb' do <<-TEXT
class ContactMailerPreview
  def new_message_email
    ContactMailer.new_message_email(ContactMessage.all.to_a.sample)
  end
end
TEXT
end


if mongoid
create_file 'config/mongoid.yml' do <<-TEXT
development:
  sessions:
    default:
      database: #{app_name.downcase}
      hosts:
          - localhost:27017
production:
  sessions:
    default:
      database: #{app_name.downcase}
      hosts:
          - localhost:27017
test:
  sessions:
    default:
      database: #{app_name.downcase}_test
      hosts:
          - localhost:27017
TEXT
end
else
remove_file 'config/database.yml'
create_file 'config/database.yml' do <<-TEXT
development:
  adapter: postgresql
  encoding: unicode
  database: #{app_name.downcase}_development
  pool: 5
  username: #{app_name.downcase}
  password: #{app_name.downcase}
  template: template0
TEXT
end
say "Please create a PostgreSQL user #{app_name.downcase} with password #{app_name.downcase} and a database #{app_name.downcase}_development owned by him for development NOW.", :red
ask("Press <enter> when done.", true)
end

unless mongoid
  generate 'simple_captcha'
end

generate "devise:install"
generate "devise", "User"
remove_file "config/locales/devise.en.yml"
remove_file "config/locales/en.yml"

gsub_file 'app/models/user.rb', '# :confirmable, :lockable, :timeoutable and :omniauthable', '# :confirmable, :registerable, :timeoutable and :omniauthable'
gsub_file 'app/models/user.rb', ':registerable,', ' :lockable,'
if mongoid
gsub_file 'app/models/user.rb', '# field :failed_attempts', 'field :failed_attempts'
gsub_file 'app/models/user.rb', '# field :unlock_token', 'field :unlock_token'
gsub_file 'app/models/user.rb', '# field :locked_at', 'field :locked_at'

inject_into_file 'app/models/user.rb', before: /^end/ do <<-TEXT

  field :name,    type: String
  field :login,   type: String
  field :roles,   type: Array, default: []

  before_save do
    self.roles ||= []
    self.roles.reject! { |r| r.blank? }
  end

  AVAILABLE_ROLES = ["admin", "manager", "client"]

  AVAILABLE_ROLES.each do |r|
    class_eval <<-EVAL
      def \#{r}?
        self.roles and self.roles.include?("\#{r}")
      end

      scope :\#{r.pluralize}, -> { any_in(roles: "\#{r}") }
    EVAL
  end

  rails_admin do
    list do
      field :email
      field :name
      field :login
      field :roles do
        pretty_value do
          bindings[:view].content_tag(:p, bindings[:object].roles.join(", "))
        end
      end
    end

    edit do
      field :email, :string do
        visible do
          bindings[:controller].current_user.admin? or (bindings[:controller].current_user.manager? bindings[:controller].current_user == bindings[:object])
        end
      end
      field :name, :string
      field :login, :string do
        visible do
          bindings[:controller].current_user.admin?
        end
      end
      field :roles, :enum do
        enum do
          AVAILABLE_ROLES
        end

        multiple do
          true
        end

        visible do
          bindings[:controller].current_user.admin?
        end
      end

      field :password do
        visible do
          bindings[:controller].current_user.admin? or bindings[:controller].current_user == bindings[:object]
        end
      end
      field :password_confirmation do
        visible do
          bindings[:controller].current_user.admin? or bindings[:controller].current_user == bindings[:object]
        end
      end
    end
  end
TEXT
end
end

if mongoid
  generate "ckeditor:install", "--orm=mongoid", "--backend=paperclip"
else
  generate "ckeditor:install", "--orm=active_record", "--backend=paperclip"
end

unless mongoid
  generate "rocket_cms:migration"
  generate "rails_admin_settings:migration"
end

generate "rocket_cms:admin"
generate "rocket_cms:ability"
generate "rocket_cms:layout"

unless mongoid
  rake "db:migrate"
end

generate "simple_form:install"

generate "rspec:install"

remove_file 'config/routes.rb'
create_file 'config/routes.rb' do <<-TEXT
Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'

  get 'contacts' => 'contacts#new', as: :contacts
  post 'contacts' => 'contacts#create', as: :create_contacts
  get 'contacts/sent' => 'contacts#sent', as: :contacts_sent

  get 'search' => 'search#index', as: :search

  resources :news, only: [:index, :show]

  root to: 'home#index'

  get '*slug' => 'pages#show'
  resources :pages, only: [:show]
end
TEXT
end

create_file 'config/locales/ru.yml' do <<-TEXT
ru:
  attributes:
    is_default: По умолчанию
  mongoid:
    models:
      item: Товар
    attributes:
      item:
        price: Цена
TEXT
end

remove_file 'db/seeds.rb'

require 'securerandom'
admin_pw = SecureRandom.urlsafe_base64(6)
create_file 'db/seeds.rb' do <<-TEXT
admin_pw = "#{admin_pw}"
User.destroy_all
User.create!(email: 'admin@#{app_name.dasherize.downcase}.ru', password: admin_pw, password_confirmation: admin_pw, roles: ["admin"])
TEXT
end

create_file 'config/initializers/rack.rb' do <<-TEXT
if Rails.env.development?
  module Rack
    class CommonLogger
      alias_method :log_without_assets, :log
      #{'ASSETS_PREFIX = "/#{Rails.application.config.assets.prefix[/\A\/?(.*?)\/?\z/, 1]}/"'}
      def log(env, status, header, began_at)
        unless env['REQUEST_PATH'].start_with?(ASSETS_PREFIX) || env['REQUEST_PATH'].start_with?('/uploads')  || env['REQUEST_PATH'].start_with?('/system')
          log_without_assets(env, status, header, began_at)
        end
      end
    end
  end
end

Rack::Utils.multipart_part_limit = 0
TEXT
end

create_file 'app/assets/stylesheets/rails_admin/custom/theming.sass' do <<-TEXT
.navbar-brand
  margin-left: 0 !important

.input-small
  width: 150px

.container-fluid
  input[type=text]
    width: 380px !important
  input.ra-filtering-select-input[type=text]
    width: 180px !important
  input.hasDatepicker
    width: 180px !important

.sidebar-nav
  a
    padding: 6px 10px !important
  .dropdown-header
    padding: 10px 0px 3px 9px

.label-important
  background-color: #d9534f
.alert-notice
  color: #5bc0de

.page-header
  display: none
.breadcrumb
  margin-top: 20px

.control-group
  clear: both

.container-fluid
  padding-left: 0
  > .row
    margin: 0

.last.links
  a
    display: inline-block
    padding: 3px
    font-size: 20px

.remove_nested_fields
  opacity: 1 !important

body.rails_admin .modal
  margin: 0 auto !important
  .modal-dialog
    width: 990px !important

input[type=checkbox]
  width: 30px !important

body.rails_admin

  .root_links

    > li
      display: inline-block

  .dropdown-header
    border-top: 2px solid #777777
    text-align: right

    &:first-child
      border-top: none

.bank_row .logo_field, #edit_bank img
  background: #ccc !important

.ui-menu-item
  border: 1px solid transparent

.content > .alert
  margin-top: 20px

.badge-important
  background: red
.badge-success
  background: green

.sidebar-nav i
  margin-right: 5px

body.rails_admin .table td.paperclip_type, body.rails_admin .table td.carrierwave_type, body.rails_admin .table td.jcrop_type
  img
    max-width: 150px
    max-height: 100px
TEXT
end

remove_file 'public/robots.txt'
create_file 'public/robots.txt' do <<-TEXT
User-Agent: *
Allow: /
Disallow: /admin
Sitemap: /sitemap.xml.gz
TEXT
end


remove_file 'app/views/layouts/application.html.erb'

gsub_file 'app/views/layouts/application.html.slim', "= favicon_link_tag '/favicon.ico'", "= render partial: 'blocks/favicon' #= favicon_link_tag '/favicon.ico'"


remove_file 'config/application.rb'
create_file 'config/application.rb' do <<-TEXT
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
#{'#' if mongoid}require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module #{app_name.camelize}
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec
      g.view_specs false
      g.helper_specs false
      g.feature_specs false
      g.template_engine :slim
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    config.i18n.locale = :ru
    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.i18n.enforce_available_locales = true
    #{'config.active_record.schema_format = :sql' unless mongoid}

    #{'config.autoload_paths += %W(#{config.root}/extra)'}
    #{'config.eager_load_paths += %W(#{config.root}/extra)'}

    config.time_zone = 'Europe/Moscow'
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
  end
end

TEXT
end

remove_file 'app/assets/stylesheets/application.css'
remove_file 'app/assets/stylesheets/application.css.sass'
create_file 'app/assets/stylesheets/application.sass' do <<-TEXT
@import 'compass'
@import 'rocket_cms'

#wrapper
  width: 960px
  margin: 0 auto
  #sidebar
    float: left
    width: 200px
  #content
    float: right
    width: 750px

@import "compass/layout/sticky-footer"
+sticky-footer(50px)
TEXT
end

remove_file 'app/assets/javascripts/application.js'
remove_file 'app/assets/javascripts/application.js.coffee'
create_file 'app/assets/javascripts/application.coffee' do <<-TEXT
#= require rocket_cms
TEXT
end


#god+unicorn
remove_file 'config/unicorn.rb'
create_file 'config/unicorn.rb' do <<-TEXT
worker_processes 2
working_directory "/home/ack/www/#{app_name.downcase}"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 30

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "/home/ack/www/#{app_name.downcase}/tmp/sockets/unicorn.sock", :backlog => 64

pid "/home/ack/www/qiwi_middleware/tmp/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "/home/ack/www/#{app_name.downcase}/log/unicorn.stderr.log"
stdout_path "/home/ack/www/#{app_name.downcase}/log/unicorn.stdout.log"


before_fork do |server, worker|
  server.logger.info("worker=#{worker.nr} spawning in #{Dir.pwd}")

  # graceful shutdown.
  old_pid_file = "/home/ack/www/#{app_name.downcase}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid_file) && server.pid != old_pid_file
    begin
      old_pid = File.read(old_pid_file).to_i
      server.logger.info("sending QUIT to #{old_pid}")
      # we're killing old unicorn master right there
      Process.kill("QUIT", old_pid)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

## no need for noSQL
# before_fork do |server, worker|
# # This option works in together with preload_app true setting
# # What is does is prevent the master process from holding
# # the database connection
#   defined?(ActiveRecord::Base) and
#       ActiveRecord::Base.connection.disconnect!
# end
#
# after_fork do |server, worker|
# # Here we are establishing the connection after forking worker
# # processes
#   defined?(ActiveRecord::Base) and
#       ActiveRecord::Base.establish_connection
# end
TEXT
end

remove_file 'config/unicorn.god'
create_file 'config/unicorn.god' do <<-TEXT
# http://unicorn.bogomips.org/SIGNALS.html

rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = ENV['RAILS_ROOT'] || File.dirname(File.dirname(__FILE__))

God.watch do |w|
  w.name = "unicorn_qiwi_middleware"
  w.interval = 30.seconds # default

  # unicorn needs to be run from the rails root
  w.start = "cd #{rails_root} && unicorn -c #{rails_root}/config/unicorn.rb -E #{rails_env} -D"

  # QUIT gracefully shuts down workers
  w.stop = "kill -KILL `cat #{rails_root}/tmp/pids/unicorn.pid`"

  # USR2 causes the master to re-create itself and spawn a new worker pool
  w.restart = "kill -USR2 `cat #{rails_root}/tmp/pids/unicorn.pid`"# && cd #{rails_root} && unicorn -c #{rails_root}/config/unicorn.rb -E #{rails_env} -D"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{rails_root}/tmp/pids/unicorn.pid"

  w.uid = 'ack'
  w.gid = 'ack'

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 150.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 40.percent
      c.times = 5
    end
  end

  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
TEXT
end



#scripts
remove_file 'scripts/assets_precompile.sh'
create_file 'scripts/assets_precompile.sh' do <<-TEXT
#!/bin/sh

RAILS_ENV=production rake assets:precompile
TEXT
end

remove_file 'scripts/bundle_production.sh'
create_file 'scripts/bundle_production.sh' do <<-TEXT
#!/bin/sh

rm Gemfile.lock
bundle install --without development test
TEXT
end

remove_file 'scripts/full_assets_precompile.sh'
create_file 'scripts/full_assets_precompile.sh' do <<-TEXT
#!/bin/sh

RAILS_ENV=production rake assets:precompile
TEXT
end

remove_file 'scripts/restart_thru_kill.sh'
create_file 'scripts/restart_thru_kill.sh' do <<-TEXT
#!/bin/sh

kill $(cat ./tmp/pids/unicorn.pid)
TEXT
end

remove_file 'scripts/send_usr2.sh'
create_file 'scripts/send_usr2.sh' do <<-TEXT
#!/bin/sh

kill -USR2 $(cat ./tmp/pids/unicorn.pid)
TEXT
end

remove_file 'scripts/send_hup.sh'
create_file 'scripts/send_hup.sh' do <<-TEXT
#!/bin/sh

kill -HUP $(cat ./tmp/pids/unicorn.pid)
TEXT
end

inject_into_file 'config/initializers/assets.rb', before: /\z/ do <<-TEXT
Rails.application.config.assets.precompile += %w( ckeditor/* )
TEXT
end



if mongoid
  FileUtils.cp(Pathname.new(destination_root).join('config', 'mongoid.yml').to_s, Pathname.new(destination_root).join('config', 'mongoid.yml.example').to_s)
else
  FileUtils.cp(Pathname.new(destination_root).join('config', 'database.yml').to_s, Pathname.new(destination_root).join('config', 'database.yml.example').to_s)
end

FileUtils.cp(Pathname.new(destination_root).join('config', 'secrets.yml').to_s, Pathname.new(destination_root).join('config', 'secrets.yml.example').to_s)

unless mongoid
  generate "paper_trail:install"
  generate "friendly_id"
  rake "db:migrate"
end

git :init
git add: "."
git commit: %Q{ -m 'Initial commit' }
