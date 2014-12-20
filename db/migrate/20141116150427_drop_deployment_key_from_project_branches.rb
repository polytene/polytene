class DropDeploymentKeyFromProjectBranches < ActiveRecord::Migration
  def change
    remove_column :project_branches, :deployment_key
  end
end
