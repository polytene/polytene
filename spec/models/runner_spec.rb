require 'rails_helper'

RSpec.describe Runner, :type => :model do
   describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:private_token) }
    it { should validate_uniqueness_of(:private_token) }
  end
end
