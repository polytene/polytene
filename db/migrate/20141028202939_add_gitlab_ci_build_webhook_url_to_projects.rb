class AddGitlabCiBuildWebhookUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :gitlab_ci_build_webhook_url, :string
  end
end
