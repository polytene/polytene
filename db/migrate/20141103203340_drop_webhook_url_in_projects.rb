class DropWebhookUrlInProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :gitlab_ci_build_webhook_url
  end
end
