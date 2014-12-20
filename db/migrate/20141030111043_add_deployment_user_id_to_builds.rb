class AddDeploymentUserIdToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :deployment_user_id, :integer
  end
end
