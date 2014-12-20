require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validations' do  
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:private_token) }

    describe 'private token' do
      it "should have private token" do
        user = create(:user)
        expect(user.private_token).not_to be_blank
      end
    end

    describe "Respond to" do
      it { should respond_to(:has_role?) }
    end

    describe 'email' do
      it 'accepts info@example.com' do
        user = build(:user, email: 'info@example.com')
        expect(user).to be_valid
      end

      it 'accepts info+test@example.com' do
        user = build(:user, email: 'info+test@example.com')
        expect(user).to be_valid
      end

      it "accepts o'reilly@example.com" do
        user = build(:user, email: "o'reilly@example.com")
        expect(user).to be_valid
      end

      it 'rejects test@test@example.com' do
        user = build(:user, email: 'test@test@example.com')
        expect(user).to be_invalid
      end

      it 'rejects mailto:test@example.com' do
        user = build(:user, email: 'mailto:test@example.com')
        expect(user).to be_invalid
      end

      it "rejects lol!'+=?><#$%^&*()@gmail.com" do
        user = build(:user, email: "lol!'+=?><#$%^&*()@gmail.com")
        expect(user).to be_invalid
      end
    end
  end
end
