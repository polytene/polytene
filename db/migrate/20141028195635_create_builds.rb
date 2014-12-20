class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :gitlab_ci_id
      t.string :status
      t.timestamp :started_at
      t.timestamp :finished_at
      t.integer :gitlab_ci_project_id
      t.string :ref
      t.string :sha
      t.string :deployment_status
      t.integer :project_id

      t.timestamps
    end
  end
end
