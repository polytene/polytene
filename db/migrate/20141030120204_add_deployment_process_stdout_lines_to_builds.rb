class AddDeploymentProcessStdoutLinesToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :deployment_process_stdout_lines, :text, :array => true, default: '{}'
    add_column :builds, :deployment_process_stderr_lines, :text, :array => true, default: '{}'
    add_column :builds, :deployment_process_status, :boolean, :default => false
  end
end
