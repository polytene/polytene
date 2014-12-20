class AddRunnerTokenToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :runner_token, :string
  end
end
