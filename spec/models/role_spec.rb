require 'rails_helper'

RSpec.describe Role, :type => :model do
  describe 'validations' do  
    it { should validate_uniqueness_of(:abbr) }
  end
end
