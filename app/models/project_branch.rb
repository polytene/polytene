class ProjectBranch < ActiveRecord::Base
  belongs_to :project
  has_many :builds
  
  after_save :update_builds_associations
  after_initialize :set_default_dummy_script
  after_initialize :set_default_deployment_type
  after_initialize :set_default_environment

  validates_presence_of :project_id
  validates_presence_of :branch_name
  validates_presence_of :deployment_type
  validates :deployment_type, inclusion: { in: %w(manual auto)}
  validates :branch_name, uniqueness: { scope: :project_id}

  default_value_for :default_environment, 'production'

  has_paper_trail

  rails_admin do
    show do
      field :deployment_script do
        pretty_value do
          "<pre>#{value}</pre>".html_safe
        end
      end
      include_all_fields
    end

    list do
      field :project
      field :branch_name
      field :deployment_type
      field :builds
    end

    edit do
      exclude_fields :builds
    end
  end

  class Entity < Grape::Entity
    expose :branch_name
    expose :deployment_script
    expose :default_environment
    expose :polytene_artifacts_dir
  end

  def deployment_notification_email_recipients_emails
    self.deployment_notification_email_recipients.split(/[\s,\,,;]/).reject(&:blank?).map{|e| e.strip}.select{|e| e.is_email?} if self.deployment_notification_email_recipients
  end

  def deployment_type_enum
    %w(manual auto)
  end

  def commands
    self.deployment_script.split(/[\r\n]+/)
  end

  private

  def set_default_environment
    self.default_environment ||= 'production'
  end

  def set_default_deployment_type
    self.deployment_type ||= 'manual'
  end

  def set_default_dummy_script
    self.deployment_script ||= 'ls -al'
  end

  def update_builds_associations
    self.project.builds.each do |build|
      determined_project_branch = build.determine_current_project_branch
      build.update_column(:project_branch_id, determined_project_branch.id) if determined_project_branch && determined_project_branch.id != build.project_branch_id
    end
  end
end
