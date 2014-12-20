class AddDefaultEnvironmentToProjectBranches < ActiveRecord::Migration
  def change
    add_column :project_branches, :default_environment, :string
  end
end
