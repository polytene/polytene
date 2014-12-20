class ChangeColumnDataTypeForBuildsDeploymentProcessStatus < ActiveRecord::Migration
  def change
    remove_column :builds, :deployment_process_status
    add_column :builds, :deployment_process_status, :integer
  end
end
