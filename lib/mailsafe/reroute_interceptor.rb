module Mailsafe
  class RerouteInterceptor
    def self.delivering_email(message)
      unless Mailsafe.override_receiver.blank?
        message.subject = "[#{message.to}] #{message.subject}"
        message.to = Mailsafe.override_receiver
      end
    end
  end
end
