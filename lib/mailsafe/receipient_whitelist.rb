require 'mailsafe/receipient_whitelist'

module Mailsafe
  class ReceipientWhitelist
    def self.filter_receipient_domain(message)
      allowed_domain = Mailsafe.allowed_domain
      if allowed_domain.present?
        receipients = []
        message.to.each do |receipient|
          if email_has_domain?(receipient, allowed_domain)
            receipients << receipient 
          end
        end
        message.to = receipients
      end
    end

    def self.email_has_domain?(email, allowed_domain_config)
      allowed_domains = allowed_domain_config.split(',').map(&:strip).map(&:downcase)
      email_domain = email.split("@")[1]

      if email_domain.present?
        allowed_domains.include? email_domain.downcase
      else
        false
      end
    end
  end
end

# Unfortunately, monkeypatching Mail is the only way I found to actually prevent sending an email 
require 'mail'

class Mail::Message
  def deliver_with_recipient_filter
    Mailsafe::ReceipientWhitelist.filter_receipient_domain(self)
    self.deliver_without_recipient_filter unless self.to.blank? || self.to.empty?
  end

  alias_method_chain :deliver, :recipient_filter
end
