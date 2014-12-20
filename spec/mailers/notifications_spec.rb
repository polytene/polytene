require "rails_helper"

RSpec.describe Notifications, :type => :mailer do
  describe "deployment_finished" do
    let(:build) { build_stubbed(:build, :project => build_stubbed(:project)) }
    let(:mail) { Notifications.deployment_finished(['ala_ma_kota@example.com'], build) }

    it "renders the headers" do
      expect(mail.to).to eq(["ala_ma_kota@example.com"])
      expect(mail.subject).to include("finished with status")
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("is already finished with status")
    end
  end

end
