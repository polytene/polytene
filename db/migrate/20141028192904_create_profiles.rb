class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :gitlab_private_token
      t.string :gitlab_url
      t.string :gitlab_ci_url
      t.text :gitlab_pub_key
      t.string :gitlab_email

      t.timestamps
    end
  end
end
