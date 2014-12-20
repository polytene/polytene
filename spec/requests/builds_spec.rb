require 'rails_helper'

describe Polytene::API do
  include Rack::Test::Methods

  def app
    Polytene::API
  end

  before do
    @project = create(:project, :gitlab_ci_id => rand(99999), :token => '121xx21')
    @build = create(:build, :gitlab_ci_id => rand(99999), :project_id => @project.id)

    @data = {:build_id => rand(12412), 
             :project_id => @project.id, 
             :build_status => 'failed', 
             :build_started_at => Time.now, 
             :build_finished_at => Time.now, 
             :ref => 'master', 
             :sha => '323423424242', 
             :before_sha => '4567565656', 
             :push_data => {}.to_json, 
             :gitlab_ci_id => @project.id,
             :project_id => @project.gitlab_ci_id
    }
  end

  describe Polytene::API do
    describe 'POST /api/v1/builds/:token/create' do
      it 'returns message ok and status 201 if all parameteres are present' do
        post '/api/v1/builds/'+@project.token+'/create', @data
        expect(last_response.status).to eq(201)
      end

      it 'returns 404 if no project is found' do
        post '/api/v1/builds/1aa/create', @data
        expect(last_response.status).to eq(404)
      end

      it 'returns 400 for request with not all reqiured attributes' do
        #required_attributes! [:build_id, :token, :project_id, :build_status, :build_started_at, :build_finished_at, :ref, :sha, :before_sha, :push_data]
        post '/api/v1/builds/'+@project.token+'/create'
        expect(last_response.status).to eq(400)
      end
    end
  end
end
