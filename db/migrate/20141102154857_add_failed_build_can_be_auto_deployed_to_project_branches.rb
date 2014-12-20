class AddFailedBuildCanBeAutoDeployedToProjectBranches < ActiveRecord::Migration
  def change
    add_column :project_branches, :failed_build_can_be_auto_deployed, :boolean, :default => false
  end
end
