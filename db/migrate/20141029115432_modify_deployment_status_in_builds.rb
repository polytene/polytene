class ModifyDeploymentStatusInBuilds < ActiveRecord::Migration
  def change
    change_column :builds, :deployment_status, :string, :default => 'not_initialized'
  end
end
