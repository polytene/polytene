class AddIndexToProjectBranches < ActiveRecord::Migration
  def change
    add_index :project_branches, [:project_id, :branch_name]
  end
end
