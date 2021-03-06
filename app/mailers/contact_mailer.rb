class ContactMailer < ActionMailer::Base
  def new_message_email(message)
    @message = message

    #if message.attachment?
    #  attachments[message.attachment.identifier] = File.read(message.attachment.current_path)
    #end

    mail(
        from: Settings.default_email_from(default: 'noreply@rscx.ru'),
        to: Settings.form_email(default: 'i43ack@gmail.com'),
        subject: "[#{Settings.email_topic(default: 'с сайта')}] #{message.name} #{message.email}"
    )
  end
end
