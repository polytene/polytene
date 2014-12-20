class AddGitlabDeployKeyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :gitlab_deploy_key, :text
  end
end
