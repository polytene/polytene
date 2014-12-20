class AddDefaultsToProjectBranches < ActiveRecord::Migration
  def change
    change_column :project_branches, :deployment_type, :string, :default => 'manual'
  end
end
