class AddRunnerIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :runner_id, :integer
  end
end
