class RemoveGitlabDeployKeyFromEverywhere < ActiveRecord::Migration
  def change
    remove_column :profiles, :gitlab_deploy_key
    remove_column :projects, :gitlab_deploy_key
  end
end
