module RocketCMS
  module Models
    module Mongoid
      module Page
        extend ActiveSupport::Concern
        include ManualSlug
        included do
          field :regexp, type: String
          field :redirect, type: String
          field :excerpt, type: String, localize: RocketCMS.configuration.localize
          field :content, type: String, localize: RocketCMS.configuration.localize
          field :fullpath, type: String
          has_and_belongs_to_many :menus, inverse_of: :pages
          acts_as_nested_set
          manual_slug :name

          scope :sorted, -> { order_by([:lft, :asc]) }
          scope :menu, ->(menu_id) { enabled.sorted.where(menu_ids: menu_id) }
        end
      end
    end
  end
end
