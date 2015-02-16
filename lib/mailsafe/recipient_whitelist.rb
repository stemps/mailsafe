module Mailsafe
  class RecipientWhitelist
    def initialize(message)
      @message = message
      @allowed_domain_config = Mailsafe.allowed_domain
      @allowed_domains = parse_allowed_domains
    end

    def filter_recipient_domains
      return unless @allowed_domains.present?
      [ :to, :cc, :bcc ].each { |rec_type| filter_receipient_type(rec_type) }
    end

    private

    def filter_receipient_type(rec_type)
      receivers = @message.send(rec_type)
      return unless receivers

      receivers.select! { |recipient| email_has_domain?(recipient) }
      @message.send("#{rec_type}=", receivers)
    end

    def email_has_domain?(email_address)
      email_domain = extract_domain_from_address(email_address)
      email_domain.present? && @allowed_domains.include?(email_domain)
    end

    def extract_domain_from_address(email_address)
      email_address.split("@")[1].try(:downcase)
    end

    def parse_allowed_domains
      if @allowed_domain_config.present?
        @allowed_domain_config.split(',').map(&:strip).map(&:downcase) 
      end
    end
  end

end

# Unfortunately, monkeypatching Mail is the only way I found to actually prevent sending an email 
require 'mail'

class Mail::Message
  def deliver_with_recipient_filter
    Mailsafe::RecipientWhitelist.new(self).filter_recipient_domains
    self.deliver_without_recipient_filter unless self.to.blank? || self.to.empty?
  end

  alias_method_chain :deliver, :recipient_filter
end
