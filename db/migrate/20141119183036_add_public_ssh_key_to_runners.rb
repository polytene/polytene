class AddPublicSshKeyToRunners < ActiveRecord::Migration
  def change
    add_column :runners, :public_ssh_key, :text
  end
end
