require 'rails_helper'

RSpec.describe Build, :type => :model do
  describe 'validations' do  
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:deployment_status) }
    it { should validate_presence_of(:gitlab_ci_id) }
    it { should validate_presence_of(:gitlab_ci_project_id) }
    it { should validate_presence_of(:project_id) }
    it { should validate_inclusion_of(:status).in_array(%w(success failed))}
    it { should validate_inclusion_of(:deployment_status).in_array(%w(not_initialized initialized running succeeded failed))}
  end

  describe :status do
    it "accepts success" do
      build = build(:build, status: "success", project_id: 1)
      expect(build).to be_valid
    end

    it "rejects d9ka" do
      build = build(:build, status: "d9ka")
      expect(build).to be_invalid
    end
  end

  describe :deployment_status do
    it "accepts succeeded" do
      build = build(:build, deployment_status: "succeeded", project_id: 1)
      expect(build).to be_valid
    end

    it "rejects d9ka" do
      build = build(:build, deployment_status: "d9ka")
      expect(build).to be_invalid
    end
  end


end
