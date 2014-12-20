class AddIdToUserRoles < ActiveRecord::Migration
  def change
    add_column :roles_users, :id, :primary_key
  end
end
