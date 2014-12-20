require 'rails_helper'

RSpec.describe ProjectBranch, :type => :model do
  describe 'validations' do  
    it { should validate_inclusion_of(:deployment_type).in_array(%w(manual auto))}
    it { should validate_presence_of(:project_id) }
    it { should validate_presence_of(:branch_name) }
    it { should validate_presence_of(:deployment_type) }
  end
end
