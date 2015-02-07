require 'spec_helper'

module Mailsafe
  describe RerouteInterceptor do

    describe ".delivering_mail" do
      subject            { Mail.new(to: to, cc: cc, bcc: bcc, subject: mail_subject) }
      let(:to)           { nil }
      let(:cc)           { nil }
      let(:bcc)          { nil }
      let(:override_rec) { nil }
      let(:mail_subject) { "Hi!" }

      before do
        Mailsafe.override_receiver = override_rec
        RerouteInterceptor.delivering_email(subject) 
      end

      context "override_receiver is not set" do
        let(:to)           { "joe@example.com" }
        let(:cc)           { "jane@example.com" }
        let(:bcc)          { "bob@example.com" }

        # leaves the email unchanged
        specify { expect(subject.subject).to eq mail_subject }
        specify { expect(subject.to).to eq [to] }
        specify { expect(subject.cc).to eq [cc] }
        specify { expect(subject.bcc).to eq [bcc] }
      end

      context "override_receiver is set" do
        let(:override_rec) { "override@example.com" }

        context "Message without any receivers" do
          specify { expect(subject.subject).to eq "[] Hi!" }
          specify { expect(subject.to).to eq [override_rec] }
          specify { expect(subject.cc).to eq [] }
          specify { expect(subject.bcc).to eq [] }
        end

        context "message with a 'to' receiver" do
          let(:to) { "bob@example.com" }

          specify { expect(subject.subject).to eq "[to: bob@example.com] Hi!" }
          specify { expect(subject.to).to eq [override_rec] }
          specify { expect(subject.cc).to eq [] }
          specify { expect(subject.bcc).to eq [] }
        end

        context "message with multiple 'to' receivers" do
          let(:to) { ["bob@example.com", "jane@example.com"] }

          specify { expect(subject.subject).to eq "[to: bob@example.com, jane@example.com] Hi!" }
          specify { expect(subject.to).to eq [override_rec] }
          specify { expect(subject.cc).to eq [] }
          specify { expect(subject.bcc).to eq [] }
        end

        context "message with 'to', 'cc' and 'bcc' receivers" do
          let(:to) { ["bob@example.com", "jane@example.com"] }
          let(:cc) { "joe@example.com" }
          let(:bcc) { ["mary@example.com", "alice@example.com"] }

          specify { expect(subject.subject).to eq "[to: bob@example.com, jane@example.com; cc: joe@example.com; bcc: mary@example.com, alice@example.com] Hi!" }
          specify { expect(subject.to).to eq [override_rec] }
          specify { expect(subject.cc).to eq [] }
          specify { expect(subject.bcc).to eq [] }
        end
      end
    end
  end
end
