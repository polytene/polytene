class ChangeGitlabPubKeyToGitlabDeployKeyInProfiles < ActiveRecord::Migration
  def change
    rename_column :profiles, :gitlab_pub_key, :gitlab_deploy_key
  end
end
