class Indexes < ActiveRecord::Migration
  def change
    add_index(:builds, :gitlab_ci_id)
    add_index(:builds, :status)
    add_index(:builds, :project_id)
    add_index(:builds, :project_branch_id)
    
    add_index(:projects, :gitlab_ci_id)
    add_index(:projects, :gitlab_id)
    add_index(:projects, :runner_id)
    add_index(:projects, :user_id)
    
    add_index(:project_branches, :project_id)
    add_index(:project_branches, :branch_name)

    add_index(:runners, :user_id)
  end
end
