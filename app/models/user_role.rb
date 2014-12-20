class UserRole < ActiveRecord::Base
  self.table_name = 'roles_users'

  belongs_to :user
  belongs_to :role

  validates :user_id, uniqueness: { scope: :role_id}
end
