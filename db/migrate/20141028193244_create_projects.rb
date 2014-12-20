class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :gitlab_ci_id
      t.string :gitlab_ci_name
      t.string :gitlab_ci_token
      t.string :gitlab_ci_default_ref
      t.string :gitlab_url
      t.string :gitlab_ssh_url_to_repo
      t.integer :gitlab_id
      t.integer :user_id

      t.timestamps
    end
  end
end
