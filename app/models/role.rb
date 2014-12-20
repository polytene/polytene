class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :user_roles, :dependent => :destroy

  validates :name, :abbr, presence: true
  validates :abbr, uniqueness: true

  rails_admin do
    edit do
      field :abbr
      field :name
    end
  end
end
