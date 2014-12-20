class AddDeploymentJobIdToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :deployment_job_id, :integer
  end
end
