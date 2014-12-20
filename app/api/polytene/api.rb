require_relative 'helpers.rb'

module Polytene
  class API < Grape::API
    version 'v1', using: :path, vendor: 'polytene'
    format :json
    prefix :api
    default_format :json

    before do
      header "X-Robots-Tag", "noindex"
    end

    helpers PolyteneApiHelpers

    resources :builds do
      post ':token/create' do
        required_attributes! [:build_id, :token, :project_id, :build_status, :build_started_at, :build_finished_at, :ref, :sha, :before_sha, :push_data]

        project = Project.where(:token => params[:token], :gitlab_ci_id => params[:project_id]).first

        if project
          build = Build.where(:project_id => project.id, :gitlab_ci_id => params[:build_id]).first_or_initialize
          build.status = params[:build_status]
          build.started_at = params[:build_started_at]
          build.finished_at = params[:build_finished_at]
          build.ref = params[:ref]
          build.sha = params[:sha]
          build.gitlab_ci_project_id = params[:project_id]
          build.before_sha = params[:before_sha]
          build.push_data = params[:push_data].to_json

          if build.save
            status 201
            message = 'ok'
          else
            status 400
            message = "cant save. errors: #{build.errors.as_json}"
          end
        else
          message = "Project not found"
          status 404
        end

        present :message, message
      end
    end

    resource :runners do
      post :update_build do
        authenticate_runner!
        update_last_seen_for_runner
        required_attributes! [:private_token, :build_id, :stdout_trace, :stderr_trace, :state]

        ActiveRecord::Base.transaction do
          build = Build.where(:deployment_status => 'running', :id => params[:build_id], :runner_token => params[:private_token]).first
          not_found! unless build
          build.update_deployment_data!(params)

          present :message, 'ok'
        end
      end

      post :proof_of_life do
        authenticate_runner!
        update_last_seen_for_runner
        update_public_key_for_runner(params[:public_key])
        present current_runner, :with => Runner::PrivateEntity
      end

      post :get_job do
        authenticate_runner!
        update_last_seen_for_runner

        build = Build.find_first_for_deploy(current_runner.id)
        not_found! unless build

        build.runner_token = params[:private_token]
        build.deployment_status = 'running'

        if build.save
          present build, :with => Build::Entity
        else
          render_api_error!('Something went wrong', 422)
        end
      end
    end
  end
end
