class Profile < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, uniqueness: true, presence: true
  validates :gitlab_url, :allow_blank => true, :format => {:with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix}
  validates :gitlab_ci_url, :allow_blank => true, :format => {:with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix}
  validates :gitlab_email, email: {strict_mode: true}, uniqueness: false, :allow_blank => true
  
  has_paper_trail

  rails_admin do
    list do
      field :user
      field :gitlab_url
      field :gitlab_ci_url
    end
    edit do
      exclude_fields :user
    end
  end

  def gitlab_api_ver
    'v3'
  end

  def gitlab_ci_api_ver
    'v1'
  end

  def base_gitlab_ci_api_url
    File.join(self.gitlab_ci_url, 'api', self.gitlab_ci_api_ver)
  end

  def base_gitlab_api_url
    File.join(self.gitlab_url, 'api', self.gitlab_api_ver)
  end

  def name
    self.user.email if self.user
  end
end
