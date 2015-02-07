require 'spec_helper'

module Mailsafe
  describe ReceipientWhitelist do

    describe ".email_has_domain" do
      context "single whitelisted domain" do
        let!(:whitelist) { "gmail.com" }

        it "accepts the allowed domains" do
          expect(ReceipientWhitelist.email_has_domain?("bert@gmail.com", whitelist)).to be_truthy
        end

        it "does not accept other domains" do
          expect(ReceipientWhitelist.email_has_domain?("bert@gmx.de", whitelist)).to be_falsy 
          expect(ReceipientWhitelist.email_has_domain?("bert@yahoo.com", whitelist)).to be_falsy 
          expect(ReceipientWhitelist.email_has_domain?("bert@ggmail.com", whitelist)).to be_falsy 
          expect(ReceipientWhitelist.email_has_domain?("bert@gmail.com.de", whitelist)).to be_falsy 
        end
      end

      context "multiple whitelisted domains" do
        let!(:whitelist) { "gmail.com, gmx.de" }

        it "accepts the allowed domains" do
          expect(ReceipientWhitelist.email_has_domain?("bert@gmail.com", whitelist)).to be_truthy 
          expect(ReceipientWhitelist.email_has_domain?("bert@gmx.de", whitelist)).to be_truthy 
        end

        it "does not accept other domains" do
          expect(ReceipientWhitelist.email_has_domain?("bert@yahoo.com", whitelist)).to be_falsy 
          expect(ReceipientWhitelist.email_has_domain?("bert@ggmail.com", whitelist)).to be_falsy 
        end
      end

      context "invalid email addresses" do
        let!(:whitelist) { "gmail.com" }

        it "does not accept them" do
          expect(ReceipientWhitelist.email_has_domain?("bert", whitelist)).to be_falsy 
        end
      end

      context "invalid whitelist" do
        let!(:whitelist) { "gmail.com, " }

        it "accepts the allowed domains" do
          expect(ReceipientWhitelist.email_has_domain?("bert@gmail.com", whitelist)).to be_truthy 
        end

        it "does not accept other domains" do
          expect(ReceipientWhitelist.email_has_domain?("bert@gmx.de", whitelist)).to be_falsy 
          expect(ReceipientWhitelist.email_has_domain?("bert@yahoo.com", whitelist)).to be_falsy 
          expect(ReceipientWhitelist.email_has_domain?("bert@ggmail.com", whitelist)).to be_falsy 
          expect(ReceipientWhitelist.email_has_domain?("bert@gmail.com.de", whitelist)).to be_falsy 
        end
      end

    end
  end
end
