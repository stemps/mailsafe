require 'rails'
require "mailsafe/version"
require "mailsafe/railtie"
require "mailsafe/change_subject_interceptor"
require "mailsafe/reroute_interceptor"
require "mailsafe/receipient_whitelist"

module Mailsafe
  def self.setup
    yield self
  end

  # add the name of the rails environment to the subject line (e.g. "[development] original email subject")
  mattr_accessor :prefix_email_subject_with_rails_env
  @@prefix_email_subject_with_rails_env = false

  # specify a domain that is allowed to receive emails all emails to other domains are dropped. 
  # If empty, all emails are allowed to all domains
  mattr_accessor :allowed_domain
  @@allowed_domain = nil

  # re-route all email to a single receiver. Use in development to route all mail to the developer.
  mattr_accessor :override_receiver
  @@override_receiver = nil
end

