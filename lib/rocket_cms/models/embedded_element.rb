module RocketCMS
  module Models
    module EmbeddedElement
      extend ActiveSupport::Concern
      include RocketCMS::Model
      include Enableable
      include Sortable
      include RocketCMS.orm_specific('EmbeddedElement')
    end
  end
end