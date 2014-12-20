class AdditionsToBuildFromCi < ActiveRecord::Migration
  def change
    add_column :builds, :before_sha, :string
    add_column :builds, :push_data, :json
  end
end
