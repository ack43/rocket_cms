module RocketCMS
  module Models
    module Mongoid
      module ContactMessage
        extend ActiveSupport::Concern
        included do
          field :name, type: String, default: ""
          field :email, type: String, default: ""
          field :phone, type: String, default: ""
          field :content, type: String, default: ""
          RocketCMS.configuration.contacts_fields.each_pair do |fn, ft|
            next if ft.nil?
            field fn, type: ft
          end
        end
      end
    end
  end
end

