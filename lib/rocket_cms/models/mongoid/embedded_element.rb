module RocketCMS
  module Models
    module Mongoid
      module EmbeddedElement
        extend ActiveSupport::Concern

        included do
          field :name, type: String, localize: RocketCMS.configuration.localize
        end
      end
    end
  end
end