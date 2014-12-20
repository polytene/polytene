include ActionDispatch::TestProcess

FactoryGirl.define do  

  sequence(:private_token) { |n| "Private_Token_#{n}" }
  sequence(:gitlab_ci_token) { |n| "Gitlab-CI-Token_#{n}" }
  sequence(:project_token) { |n| "Project Token_#{n}" }
  sequence(:id) {|n| n}

  factory :runner do
    private_token
    user_id 1
    name "MyString"
    last_seen "2014-11-06 14:20:44"
    is_active true
  end

  factory :role do

  end

  factory :profile do
    user_id 897675454778
    gitlab_private_token "asasa9ak9jjkkxu"
    gitlab_url {Faker::Internet.uri('http')}
    gitlab_ci_url {Faker::Internet.uri('http')}
  end

  factory :project_branch do

  end

  factory :project do
    gitlab_ci_id {generate(:id)}
    gitlab_ci_name "Project from CI"
    gitlab_ci_token
    gitlab_ci_default_ref 'master'
    gitlab_url {Faker::Internet.uri('http')}
    gitlab_ssh_url_to_repo {Faker::Internet.uri('http')}
    gitlab_id 1
    user_id 1
    token {generate(:project_token)}
    runner_id 1
  end

  sequence :sentence, aliases: [:title, :content] do
    Faker::Lorem.sentence
  end

  sequence :name, aliases: [:file_name] do
    Faker::Name.name
  end

  sequence(:url) { Faker::Internet.uri('http') }

  factory :build do
    status "failed"
    started_at {Faker::Time.date}
    finished_at {Faker::Time.date}
    deployment_status "failed"
    deployment_started_at {Faker::Time.date}
    deployment_finished_at {Faker::Time.date}
    runner_token "kd9jejdlksru3o"
    sha "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    ref "master"
    gitlab_ci_id 1
    gitlab_ci_project_id 2
    before_sha 'da39a3ee5e6b4b0d3255bfef95601890afd801212'
    push_data {}.to_json
  end

  factory :user do
    email { Faker::Internet.email }
    private_token "asja8jas8hhd"
    password "12345678"
    password_confirmation { password }
  end
end
