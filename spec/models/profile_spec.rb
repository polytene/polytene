require 'rails_helper'

RSpec.describe Profile, :type => :model do
  describe 'validations' do  
    it { should validate_uniqueness_of(:user_id) }
  end

  describe :gitlab_url do
    it "accepts nil" do
      profile = build(:profile, gitlab_url: nil)
      expect(profile).to be_valid
    end

    it "accepts http://gumed.edu.pl" do
      profile = build(:profile, gitlab_url: "http://gumed.edu.pl")
      expect(profile).to be_valid
    end

    it "rejects krata_piwa@wp.platform.pl" do
      profile = build(:profile, gitlab_url: "krata_piwa@wp.platform.pl")
      expect(profile).to be_invalid
    end
  end

  describe :gitlab_ci_url do
    it "accepts nil" do
      profile = build(:profile, gitlab_ci_url: nil)
      expect(profile).to be_valid
    end

    it "accepts http://gumed.edu.pl" do
      profile = build(:profile, gitlab_ci_url: "http://gumed.edu.pl")
      expect(profile).to be_valid
    end

    it "rejects krata_piwa@wp.platform.pl" do
      profile = build(:profile, gitlab_ci_url: "krata_piwa@wp.platform.pl")
      expect(profile).to be_invalid
    end
  end

end
