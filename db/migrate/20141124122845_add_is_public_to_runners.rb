class AddIsPublicToRunners < ActiveRecord::Migration
  def change
    add_column :runners, :is_public, :boolean, :default => false
  end
end
