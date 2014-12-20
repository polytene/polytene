class Runner < ActiveRecord::Base
  belongs_to :user
  validates :private_token, uniqueness: true
  validates :name, presence: true
  validates :private_token, presence: true

  after_initialize :set_new_token
  after_update :update_deploy_keys

  has_paper_trail

  has_many :projects

  class PrivateEntity < Grape::Entity
    expose :private_token
    expose :id
  end

  rails_admin do
    
    configure :projects_count do
      pretty_value do
        bindings[:object].projects.count
      end
      read_only true
    end

    list do
      field :name
      field :last_seen
      field :is_active
      field :is_public
      field :private_token
      field :projects_count
    end
    
    edit do
      exclude_fields :user, :last_seen, :projects_count, :public_ssh_key
    end
  end

  def projects_count
    self.projects.count
  end

  def update_deploy_keys
    self.projects.each do |project|
      project.register_deploy_key_in_gitlab
    end if !self.public_ssh_key.blank? && self.public_ssh_key_changed?
  end

  private
  def set_new_token
    self.private_token ||= SecureRandom.hex
  end
end
