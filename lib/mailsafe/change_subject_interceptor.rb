module Mailsafe
  class ChangeSubjectInterceptor
    def self.delivering_email(message)
      if Mailsafe.prefix_email_subject_with_rails_env
        message.subject = "[#{Rails.env}] #{message.subject}"
      end
    end
  end
end
