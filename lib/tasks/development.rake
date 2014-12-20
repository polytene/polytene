namespace :polytene do
  namespace :development do
    desc "Generate some unreal builds for development process purpose"
    task :generate_builds => :environment do
      require 'securerandom'

      Project.all.each do |project|
        20.times do |x|
          status = ['success', 'failed'].sample
          ref = ['master', 'staging', 'fix-1'].sample

          project.builds.create({status: status, gitlab_ci_id: Random.new.rand(1..1000), gitlab_ci_project_id: project.gitlab_ci_id, project_id: project.id, ref: ref, sha: SecureRandom.hex})
        end
      end
    end
  end
end
