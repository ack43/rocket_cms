module RocketCMS
  module Models
    module ContactMessage
      extend ActiveSupport::Concern
      include RocketCMS::Model
      include RocketCMS.orm_specific('ContactMessage')

      included do

        apply_simple_captcha message: RocketCMS.configuration.contacts_captcha_error_message

        validates_email_format_of :email, unless: 'email.blank?'
        if RocketCMS.config.contacts_message_required
          validates_presence_of :content
        end
        validate do
          if email.blank? && phone.blank?
            errors.add(:email, I18n.t('rs.no_contact_info'))
          end
        end

        after_create do
          mailer_class.send(mailer_method, self).deliver
        end

        def mailer_class
          ContactMailer
        end

        def mailer_method
          :new_message_email
        end
      end
    end
  end
end
