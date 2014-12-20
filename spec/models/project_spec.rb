require 'rails_helper'

RSpec.describe Project, :type => :model do
  describe 'validations' do  
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:gitlab_ci_id) }
    it { should validate_presence_of(:gitlab_ci_name) }
    it { should validate_presence_of(:gitlab_ssh_url_to_repo) }
    it { should validate_presence_of(:gitlab_id) }
  end
end
