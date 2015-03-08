class Project < ActiveRecord::Base
  has_many :builds, :dependent => :destroy
  has_many :project_branches, :dependent => :destroy
  belongs_to :user
  belongs_to :runner

  before_save :generate_token
  after_create :create_branches

  validates_presence_of :user_id
  validates_presence_of :gitlab_ci_id
  validates_presence_of :gitlab_ci_token
  validates_presence_of :gitlab_ci_name
  validates_presence_of :gitlab_ssh_url_to_repo
  validates_presence_of :gitlab_url
  validates_presence_of :gitlab_id
  validates :gitlab_ci_id, uniqueness: { scope: :user_id}

  has_paper_trail

  rails_admin do
    configure :gitlab_ci_build_webhook_url do
      pretty_value do
        project = util = bindings[:object]
        project.gitlab_ci_build_webhook_url
      end
      read_only true
    end

    list do
      field :gitlab_ci_name
      field :gitlab_ci_default_ref
      field :builds
      field :project_branches
      field :runner
    end

    edit do
      exclude_fields :builds, :project_branches, :gitlab_ci_build_webhook_url
    end
  end

  class Entity < Grape::Entity
    expose :gitlab_ci_name
    expose :gitlab_ssh_url_to_repo
    expose :repo_url
  end

  def repo_url
    general_repo_url = self.gitlab_url
    url = URI.parse(general_repo_url)
    url.to_s + '.git'
  end

  def private_repo_url
    user = "gitlab-ci-token:#{self.gitlab_ci_token}"
    general_repo_url = self.gitlab_url
    url = URI.parse(general_repo_url)
    url.user = user
    url.to_s + '.git'
  end

  def self.create_gitlab_ci_project(params, user_id)
    project = Project.new
    project.gitlab_ci_id = params['id']
    project.gitlab_ci_name = params['name']
    project.gitlab_ci_token = params['token']
    project.gitlab_ci_default_ref = params['default_ref']
    project.gitlab_url = params['gitlab_url']
    project.gitlab_ssh_url_to_repo = params['ssh_url_to_repo']
    project.gitlab_id = params['gitlab_id']
    project.user_id = user_id

    if project.save
      project
    else
      nil
    end
  end

  def self.import_gitlab_ci_project(gitlab_ci_project_id, user_id)
    gitlab_ci_project = self.find_gitlab_ci_project(gitlab_ci_project_id, user_id)

    return nil unless gitlab_ci_project
    self.create_gitlab_ci_project(gitlab_ci_project, user_id)
  end

  def self.gitlab_ci_project_exists?(id, user_id)
    Project.exists?(:gitlab_ci_id => id, :user_id => user_id)
  end

  def self.find_gitlab_ci_project(id, user_id)
    user = User.find(user_id)
    profile = user.profile

    options = {:headers => {"Content-Type" => "application/json"}, :query => {:per_page => 10000, :private_token => profile.gitlab_private_token, :url => profile.gitlab_url}}
    endpoint = File.join(user.profile.base_gitlab_ci_api_url, 'projects', id.to_s)
    response = HTTParty.get(endpoint, options)

    if response.code == 200
      response.parsed_response
    else
      nil
    end
  end

  def gitlab_ci_build_webhook_url
    "#{Site.domain}/api/v1/builds/#{self.token}/create"
  end

  def register_deploy_key_in_gitlab
    return nil unless self.runner
    return nil if self.runner.public_ssh_key.blank?

    profile = user.profile

    title = "Polytene at #{Site.domain}, runner #{self.runner.name}"
    key = self.runner.public_ssh_key

    body = {:private_token => profile.gitlab_private_token}
    body = body.merge({title: title, key: key})

    options = {:headers => {"Content-Type" => "application/json"}, :body => body.to_json}
    endpoint = File.join(profile.base_gitlab_api_url, 'projects', self.gitlab_id.to_s, 'keys')

    response = HTTParty.post(endpoint, options)

    if response.code == 201
      response.parsed_response
    else
      nil
    end
  end

  def register_webhook
    profile = user.profile

    options = {:headers => {"Content-Type" => "application/json"}, :query => {
      :private_token => profile.gitlab_private_token,
      :url => profile.gitlab_url,
      :web_hook => gitlab_ci_build_webhook_url}
    }

    endpoint = File.join(profile.base_gitlab_ci_api_url, 'projects', gitlab_ci_id.to_s, 'webhooks')
    response = HTTParty.post(endpoint, options)

    if response.code == 201
      true
    else
      nil
    end
  end

  private
  def create_branches
    self.gitlab_ci_default_ref.split(",").map{|d| d.strip}.reject(&:blank?).each do |branch_name|
      self.project_branches.create({:branch_name => branch_name, :deployment_notification_email_recipients => self.user.email})
    end
  end

  def generate_token
    require 'securerandom'

    self.token = SecureRandom.hex if self.token.blank?
  end
end
