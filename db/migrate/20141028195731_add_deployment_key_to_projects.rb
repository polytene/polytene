class AddDeploymentKeyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deployment_key, :text
  end
end
