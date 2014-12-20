class PolyteneArtifactsDirToProjectBranches < ActiveRecord::Migration
  def change
    add_column :project_branches, :polytene_artifacts_dir, :string, :default => 'polytene'
  end
end
