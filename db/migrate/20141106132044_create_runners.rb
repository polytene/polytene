class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.string :private_token
      t.integer :user_id
      t.string :name
      t.timestamp :last_seen
      t.boolean :is_active

      t.timestamps
    end
  end
end
