class CreateProjectBranches < ActiveRecord::Migration
  def change
    create_table :project_branches do |t|
      t.integer :project_id
      t.string :branch_name
      t.text :deployment_key
      t.string :deployment_type
      t.text :deployment_script
      t.string :deployment_notification_email_recipients

      t.timestamps
    end
  end
end
