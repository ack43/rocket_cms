module BooleanField
  extend ActiveSupport::Concern
  module ClassMethods
    def boolean_field(name, default = true)
      field name, type: Mongoid::Boolean, default: default
      scope name, -> { where(name => true) }

      if name == 'active'
        scope :inactive,  -> { where(active: false) }
      elsif name == 'enabled'
        scope :disabled,  -> { where(enabled: false) }
      end
    end
  end
end
