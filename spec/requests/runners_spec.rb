require 'rails_helper'

describe Polytene::API do
  include Rack::Test::Methods

  def app
    Polytene::API
  end

  before do
    @active_runner = create(:runner, :is_active => true)
    @inactive_runner = create(:runner, :is_active => false)
  end

  describe Polytene::API do
    describe 'POST /api/v1/runners/update_build' do
      it 'returns message ok and status 201 if all parameteres are present and found own running deployment' do
        project_with_active_runner = create(:project, :runner => @active_runner)
        running_build = create(:build, :project => project_with_active_runner, :status => 'success', :deployment_status => 'running', :runner_token => @active_runner.private_token)

        post '/api/v1/runners/update_build.json', :private_token => @active_runner.private_token, :build_id => running_build.id, :stdout_trace => 'ala_ma_kota', :stderr_trace => 'ala_ma_kota', :state => 'succeeded'
        expect(last_response.status).to eq(201)
        json_response = ::JSON.parse(last_response.body)
        expect(json_response['message']).to eq('ok')
      end

      it 'returns 404 for request for unrecognized build' do
        post '/api/v1/runners/update_build.json', :private_token => @active_runner.private_token, :build_id => 1, :stdout_trace => 'ala_ma_kota', :stderr_trace => 'ala_ma_kota', :state => 'ala_ma_kota'
        expect(last_response.status).to eq(404)
      end

      it 'returns 401 for inactive runner' do
        post '/api/v1/runners/update_build.json', :private_token => 'ala_ma_kota'
        expect(last_response.status).to eq(401)
      end

      it 'returns 400 for request with not all reqiured attributes' do
        #required_attributes! [:private_token, :build_id, :stdout_trace, :stderr_trace, :state]
        post '/api/v1/runners/update_build.json', :private_token => @active_runner.private_token
        expect(last_response.status).to eq(400)
      end
    end

    describe 'POST /api/v1/runners/get_job.json' do
      it 'returns complete data for found build for deployment' do
        project_with_active_runner = create(:project, :runner => @active_runner)
        initialized_build = create(:build, :project => project_with_active_runner, :status => 'success', :deployment_status => 'initialized')

        post '/api/v1/runners/get_job.json', :private_token => @active_runner.private_token
        json_response = ::JSON.parse(last_response.body)
        
        expect(last_response.status).to eq(201)

        expect(json_response).to have_key('id')
        expect(json_response).to have_key('status')
        expect(json_response).to have_key('deployment_status')
        expect(json_response).to have_key('gitlab_ci_project_id')
        expect(json_response).to have_key('project_id')
        expect(json_response).to have_key('sha')
        expect(json_response).to have_key('ref')
        
        expect(json_response).to have_key('project_branch')
        expect(json_response['project_branch']).to have_key('deployment_script')
        expect(json_response['project_branch']).to have_key('default_environment')
        expect(json_response['project_branch']).to have_key('polytene_artifacts_dir')
        
        expect(json_response).to have_key('project')
        expect(json_response['project']).to have_key('repo_url')

        expect(json_response.values).not_to include(nil)
      end

      it 'returns 201 for found build for deployment' do
        project_with_active_runner = create(:project, :runner => @active_runner)
        initialized_build = create(:build, :project => project_with_active_runner, :status => 'success', :deployment_status => 'initialized')

        post '/api/v1/runners/get_job.json', :private_token => @active_runner.private_token
        expect(last_response.status).to eq(201)
      end

      it 'returns 404 for not found build for deployment' do
        project_with_active_runner = create(:project, :runner => @active_runner)
        uninitialized_build = create(:build, :project => project_with_active_runner, :status => 'success', :deployment_status => 'not_initialized')

        post '/api/v1/runners/get_job.json', :private_token => @active_runner.private_token
        expect(last_response.status).to eq(404)
      end
    end

    describe 'POST /api/v1/runners/proof_of_life.json' do
      it 'returns 201 for good private token' do
        post '/api/v1/runners/proof_of_life.json', :private_token => @active_runner.private_token
        expect(last_response.status).to eq(201)
      end

      it 'returns 401 for inactive runner' do
        post '/api/v1/runners/proof_of_life.json', :private_token => @inactive_runner.private_token
        expect(last_response.status).to eq(401)
      end

      it 'returns 401 for wrong private token' do
        post '/api/v1/runners/proof_of_life.json', :private_token => 'ala_ma_kota'
        expect(last_response.status).to eq(401)
      end
    end
  end
end
