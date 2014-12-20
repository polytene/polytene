class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :async

  validates_presence_of :private_token
  validates_presence_of :email
  validates :email, presence: true, email: {strict_mode: true}, uniqueness: true

  has_and_belongs_to_many :roles
  has_one :profile, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :builds, :through => :projects
  has_many :user_roles, :dependent => :destroy
  has_many :runners, :dependent => :destroy

  after_create :create_profile_default
  after_initialize :create_token_default

  has_paper_trail

  rails_admin do
    edit do
      field :email
      field :password
      field :password_confirmation
    end
    list do
      field :email
      field :profile
      field :stringify_roles do
        label "Roles"
      end
      field :projects_count
    end
  end

  class PrivateEntity < Grape::Entity
    expose :private_token
    expose :id
  end

  def add_role(abbr)
    role = Role.where(:abbr => abbr).first
    self.user_roles.create(:role_id => role.id) if role
  end

  def stringify_roles(sep = ',')
    self.roles.map{|r| r.name}.join(sep)
  end

  def projects_count
    self.projects.count
  end

  def self.required_profile_attributes
    ["gitlab_ci_url", "gitlab_private_token", "gitlab_url"]
  end

  def blank_required_profile_attributes
    self.profile.attributes.select{|k,v| v.blank?}.keys & self.class.required_profile_attributes
  end

  def avaiable_gitlab_ci_projects
    options = {:headers => {"Content-Type" => "application/json"}, :query => {:per_page => 10000, :private_token => self.profile.gitlab_private_token, :url => self.profile.gitlab_url}}
    endpoint = File.join(self.profile.base_gitlab_ci_api_url, 'projects')
    response = HTTParty.get(endpoint, options)

    if response.code == 200
      response.parsed_response
    else
      nil
    end
  end

  def has_imported_gitlab_ci_project?(gitlab_ci_project_id)
    Project.where(:gitlab_ci_id => gitlab_ci_project_id, :user_id => self.id).first
  end

  def has_role?(abbr)
    self.roles.where(abbr: abbr).count > 0
  end

  def self.authenticate_by_token(token, role_abbr = nil)
    user = User.where(:private_token => token).first
    return nil if user && role_abbr && !user.has_role?(role_abbr)
    user
  end

  private

  def create_token_default
    require 'securerandom'
    self.private_token ||= SecureRandom.hex
  end

  def create_profile_default
    self.create_profile({:gitlab_email => self.email}) unless self.profile
  end
end
