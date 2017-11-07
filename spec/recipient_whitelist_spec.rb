require 'spec_helper'

module Mailsafe
  describe RecipientWhitelist do
    describe ".filter_recipient_domain" do
      subject            { Mail.new(to: to, cc: cc, bcc: bcc) }
      let(:to)           { ["to@gmail.com", "to@yahoo.com"] }
      let(:cc)           { ["cc@gmail.com", "cc@yahoo.com"] }
      let(:bcc)          { ["bcc@gmail.com", "bcc@yahoo.com"] }

      context "allowed_domains configured" do
        before do
          Mailsafe.allowed_domain = "gmail.com" 
          RecipientWhitelist.new(subject).filter_recipient_domains
        end

        it "filters 'to' email addresses" do
          expect(subject.to).to eq ["to@gmail.com"]
        end

        it "filters 'cc' email addresses" do
          expect(subject.cc).to eq ["cc@gmail.com"]
        end

        it "filters 'bcc' email addresses" do
          expect(subject.bcc).to eq ["bcc@gmail.com"]
        end
      end

      context "uninitialized receivers" do
        subject { Mail.new() }

        before do
          Mailsafe.allowed_domain = "gmail.com" 
          RecipientWhitelist.new(subject).filter_recipient_domains
        end

        it "Regression: and does not crash" do
          expect(subject.to).to eq nil
          expect(subject.cc).to eq nil
          expect(subject.bcc).to eq nil
        end
      end
    end
    
    describe "#email_has_domain" do
      before { Mailsafe.allowed_domain = whitelist }
      subject { RecipientWhitelist.new(double) }

      context "single whitelisted domain" do
        let(:whitelist) { "gmail.com" }

        it "accepts the allowed domains" do
          expect(subject.send(:email_has_domain?, "bert@gmail.com")).to be_truthy
        end

        it "does not accept other domains" do
          expect(subject.send(:email_has_domain?, "bert@gmx.de")).to be_falsy 
          expect(subject.send(:email_has_domain?, "bert@yahoo.com")).to be_falsy 
          expect(subject.send(:email_has_domain?, "bert@ggmail.com")).to be_falsy 
          expect(subject.send(:email_has_domain?, "bert@gmail.com.de")).to be_falsy 
        end
      end

      context "multiple whitelisted domains" do
        let(:whitelist) { "gmail.com, gmx.de" }

        it "accepts the allowed domains" do
          expect(subject.send(:email_has_domain?, "bert@gmail.com")).to be_truthy 
          expect(subject.send(:email_has_domain?, "bert@gmx.de")).to be_truthy 
        end

        it "does not accept other domains" do
          expect(subject.send(:email_has_domain?, "bert@yahoo.com")).to be_falsy 
          expect(subject.send(:email_has_domain?, "bert@ggmail.com")).to be_falsy 
        end
      end

      context "invalid email addresses" do
        let(:whitelist) { "gmail.com" }

        it "does not accept them" do
          expect(subject.send(:email_has_domain?, "bert")).to be_falsy 
        end
      end

      context "invalid whitelist" do
        let(:whitelist) { "gmail.com, " }

        it "accepts the allowed domains" do
          expect(subject.send(:email_has_domain?, "bert@gmail.com")).to be_truthy 
        end

        it "does not accept other domains" do
          expect(subject.send(:email_has_domain?, "bert@gmx.de")).to be_falsy 
          expect(subject.send(:email_has_domain?, "bert@yahoo.com")).to be_falsy 
          expect(subject.send(:email_has_domain?, "bert@ggmail.com")).to be_falsy 
          expect(subject.send(:email_has_domain?, "bert@gmail.com.de")).to be_falsy 
        end
      end
    end
  end

  describe "integration test" do
    before do
      Mail.defaults { delivery_method :test }
      Mailsafe.setup do |config|
        config.allowed_domain = "whitelisted.com"
      end
    end

    context "with whitelisted recipients" do
      let(:recipients) { "john@whitelisted.com, joe@blacklisted.com" }
      let(:mail) do
        Mail.new.tap do |mail|
          mail[:from] = "me@example.com"
          mail[:to] = recipients
        end
      end

      it "delivers only to whitelisted recipients" do
        mail.deliver

        expect(Mail::TestMailer.deliveries.count).to eq 1
        expect(Mail::TestMailer.deliveries.first.to).to eq ["john@whitelisted.com"]
      end
    end
  end
end
