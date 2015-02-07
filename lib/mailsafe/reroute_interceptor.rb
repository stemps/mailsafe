module Mailsafe
  class RerouteInterceptor
    def self.delivering_email(message)
      unless Mailsafe.override_receiver.blank?
        message.subject = "[#{receivers(message)}] #{message.subject}"
        message.to = Mailsafe.override_receiver
        message.cc = []
        message.bcc = []
      end
    end

    private

    def self.receivers(message)
      [ :to, :cc, :bcc ].map do |rec_type|
        recs = message.send(rec_type)
        "#{rec_type}: #{recs.join ', '}" if recs.present?
      end.compact.join '; '
    end
  end
end
