class RegisterDeployKeyWorker
  include Sidekiq::Worker

  def perform(project_ids)
    [project_ids].flatten.each do |project_id|
      project = Project.find(project_id)
      project.register_deploy_key_in_gitlab if project
    end
  end

end
