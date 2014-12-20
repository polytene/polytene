class Build < ActiveRecord::Base
  belongs_to :project
  belongs_to :project_branch

  validates_with BuildValidator

  before_save :find_and_set_project_branch
  after_create :run_deployment_if_needed
  after_update :email_if_deployment_finished

  validates_presence_of :status
  validates_presence_of :deployment_status
  validates_presence_of :gitlab_ci_id
  validates_presence_of :gitlab_ci_project_id
  validates_presence_of :project_id
  validates_presence_of :sha
  validates_presence_of :ref
  validates :status, inclusion: { in: %w(success failed)}
  validates :deployment_status, inclusion: { in: %w(not_initialized initialized running succeeded failed)}

  default_value_for :deployment_status, 'not_initialized'

  scope :succeeded_build, -> { where(status: 'success') }
  scope :failed_build, -> { where(status: 'failed') }
  scope :succeeded_deployment, -> { where(deployment_status: 'succeeded') }
  scope :failed_deployment, -> { where(deployment_status: 'failed') }
  scope :public_builds, -> {joins(:project).where("projects.is_public = true")}

  include RailsAdminCharts

  has_paper_trail

  class Entity < Grape::Entity
    expose :id
    expose :name
    expose :status
    expose :started_at
    expose :finished_at
    expose :deployment_status
    expose :deployment_started_at
    expose :deployment_finished_at
    expose :runner_token
    expose :gitlab_ci_id
    expose :gitlab_ci_project_id
    expose :project_id
    expose :project_branch_id
    expose :sha
    expose :ref
    expose :project_branch, with: ProjectBranch::Entity
    expose :project, with: Project::Entity
  end

  rails_admin do
    show do
      include_all_fields
      field :push_data do
        pretty_value do
          bindings[:view].json_pp(bindings[:object].push_data)
        end
      end
    end
    edit do
      exclude_fields :project_branch, :deployment_started_at, :deployment_finished_at, :deployment_job_id, :deployment_user_id, :deployment_process_status
    end
    list do
      scopes [:succeeded_build, :failed_build, :succeeded_deployment, :failed_deployment, nil]
      sort_by :started_at
      field :project
      field :ref 
      field :short_sha
      field :status do
        pretty_value do
          bindings[:view].build_status(bindings[:object].status)
        end
      end
      field :deployment_status do
        pretty_value do
          bindings[:view].deployment_status_badge(bindings[:object].deployment_status)
        end
      end
      field :deployment_started_at
      field :started_at do
        sort_reverse true
      end
    end
  end

  def self.graph_data since=30.days.ago
    [
      {
        name: 'Succeeded deployments',
        pointInterval: 1.day*1000,
        pointStart: since.to_i*1000,
        data: self.where(deployment_status: 'succeeded').delta_records_since(since)
      },
      {
        name: 'Failed deployments',
        pointInterval: 1.day*1000,
        pointStart: since.to_i*1000,
        data: self.where(deployment_status: 'failed').delta_records_since(since)
      }
    ]
  end

  def self.delta_records_since(since = 30.days.ago)
    deltas = self.group("DATE(#{self.table_name}.created_at)").count
    (since.to_date..Date.today).map { |date| deltas[date] || deltas[date.to_s] || 0 }
  end

  def build_failed?
    (self.status == 'failed')
  end

  def build_succeeded?
    (self.status == 'success')
  end

  def deployment_failed?
    (self.deployment_status == 'failed')
  end

  def deployment_running?
    (self.deployment_status == 'running')
  end

  def deployment_initialized?
    (self.deployment_status == 'initialized')
  end

  def deployment_pending?
    self.deployment_running? || self.deployment_initialized?
  end

  def deployment_type
    self.project_branch.deployment_type if self.project_branch
  end

  def deployment_succeeded?
    (self.deployment_status == 'succeeded')
  end

  def deployment_finished?
    self.deployment_failed? || self.deployment_succeeded?
  end

  def deployment_not_initialized?
    (self.deployment_status == 'not_initialized')
  end

  def can_be_deployed_automatically?
    self.deployment_type == 'auto' && (self.build_succeeded? || (self.project_branch && self.project_branch.failed_build_can_be_auto_deployed))
  end

  def valid_for_deployment?
    !self.project_branch.nil?
  end

  def can_be_deployed?
    (self.project_branch && self.deployment_not_initialized?)
  end

  def can_be_deployed_again?
    (self.project_branch && self.deployment_finished?)
  end

  def deployment_can_be_cleared?
    self.deployment_finished?
  end

  def deployment_can_be_aborted?
    self.deployment_running? || self.deployment_initialized?
  end

  def self.find_first_for_deploy(runner_id)
    self.includes(:project).where(:deployment_status => 'initialized', :projects => {:runner_id => runner_id}).first
  end

  def stdout_deployment_trace
    self.deployment_trace("output")
  end

  def stderr_deployment_trace
    self.deployment_trace("error")
  end

  def deployment_trace(type = "output")
    html = (self.deployment_process_stdout_lines.join("\n")).gsub(/(?:\n\r?|\r\n?)/, '<br>') if self.deployment_process_stdout_lines.count > 0 && type == "output"
    html = (self.deployment_process_stderr_lines.join("\n")).gsub(/(?:\n\r?|\r\n?)/, '<br>') if self.deployment_process_stderr_lines.count > 0 && type == "error"
    html ||= ''
  end

  def abort_deployment
    self.clear_deployment
  end

  def clear_deployment
    self.update_attributes({:deployment_status => 'not_initialized', :deployment_job_id => nil, :deployment_user_id => nil, :deployment_process_stdout_lines => [], :deployment_process_stderr_lines => [], :deployment_process_status => nil, :deployment_started_at => nil, :deployment_finished_at => nil, :runner_token => nil})
  end

  def update_deployment_data!(data)
    #:private_token, :build_id, :stdout_trace, :stderr_trace, :state

    self.deployment_status = data[:state]
    self.deployment_process_stdout_lines = data[:stdout_trace].split( /\r?\n/ )
    self.deployment_process_stderr_lines = data[:stderr_trace].split( /\r?\n/ )
    self.deployment_finished_at = data[:deployment_finished_at]

    deployment_process_stdout_lines_will_change!
    deployment_process_stderr_lines_will_change!

    self.save!
  end

  def initialize_for_deployment(by_user_id)
    self.deployment_user_id = by_user_id
    self.deployment_status = 'initialized'
    self.deployment_started_at = Time.now
    self.save!
  end

  def short_sha
    self.sha.to_s[0..9]
  end

  def project_name
    self.project.gitlab_ci_name
  end

  def project_has_runner?
    self.project.runner.present?
  end

  def name
    "#{self.try(:project).try(:gitlab_ci_name)} #{self.ref} #{self.short_sha}"
  end

  def determine_current_project_branch
    ProjectBranch.where(:project_id => self.project_id, :branch_name => self.ref).first
  end

  def deployment_status_enum
    %w(not_initialized initialized running succeeded failed)
  end

  def status_enum
    %w(success failed)
  end

  private

  def email_if_deployment_finished
    emails = project_branch.try(:deployment_notification_email_recipients_emails)
    Notifications.delay.deployment_finished(emails, self) if self.deployment_status_changed? && self.deployment_finished? && emails && !emails.empty?
  end

  def create_project_branch
    ProjectBranch.where(:project_id => self.project_id, :branch_name => self.ref).first_or_create! rescue false
  end

  def run_deployment_if_needed
    if self.can_be_deployed? && self.can_be_deployed_automatically?
      self.initialize_for_deployment(self.project.user_id)
    end
  end

  def find_and_set_project_branch
    determined_project_branch = self.determine_current_project_branch
    self.project_branch_id = determine_current_project_branch.id if determine_current_project_branch

    created_project_branch = create_project_branch unless determined_project_branch
    self.project_branch_id = created_project_branch.id if created_project_branch
  end
end
