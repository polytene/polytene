class AddDeploymentStartedAtToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :deployment_started_at, :timestamp
  end
end
