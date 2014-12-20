class AddDeploymentFinishedAtToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :deployment_finished_at, :timestamp
  end
end
