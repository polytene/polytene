class AddProjectBranchIdToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :project_branch_id, :integer
  end
end
