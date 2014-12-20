class AddTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :token, :string
  end
end
