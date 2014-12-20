source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'therubyracer'
gem 'rails_admin'
gem 'cancan'
gem 'devise'
gem 'paper_trail', '~> 3.0.6'
gem 'rails_admin_flatly_theme', :git => 'git://github.com/stricte/rails_admin_flatly_theme.git', :branch => 'fix_https_issue_in_chrome'
gem 'bootstrap-sass'
gem 'httparty'
gem 'humanize_boolean'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'thin'
gem 'grape'
gem 'grape-entity'
gem 'http_accept_language'
gem "default_value_for", "~> 3.0.0"
gem 'minitest'
gem 'sidekiq'
gem "devise-async"
gem 'rails_admin_charts'
gem 'devise_invitable'

group :development, :test do
  gem 'coveralls', require: false
  # gem 'rails-dev-tweaks'
  gem 'spinach-rails'
  gem "rspec-rails"
  gem "capybara", '~> 2.2.1'
  gem "pry"
  gem "awesome_print"
  gem "database_cleaner"
  gem "launchy"
  gem 'factory_girl_rails'

  # Generate Fake data
  gem "ffaker"

  # Guard
  gem 'guard-rspec'
  gem 'guard-spinach'

  # Notification
  gem 'rb-inotify'

  # PhantomJS driver for Capybara
  gem 'poltergeist', '~> 1.5.1'

  gem 'jasmine', '2.0.2'

  gem "spring", '1.1.3'
  gem "spring-commands-rspec", '1.0.1'
  gem "spring-commands-spinach", '1.0.0'

  gem "letter_opener"
end

group :test do
  gem "simplecov", require: false
  gem "shoulda-matchers"
  gem 'email_spec'
  gem "webmock"
  gem 'test_after_commit'
  gem 'rake'
end

gem 'rails_admin_import_projects', :path => './vendor/gems/rails_admin_import_projects/'
gem 'rails_admin_deploy_build', :path => './vendor/gems/rails_admin_deploy_build/'
gem 'rails_admin_build_deployment_status', :path => './vendor/gems/rails_admin_build_deployment_status/'
gem 'rails_admin_bulk_runners_registering', :path => './vendor/gems/rails_admin_bulk_runners_registering/'
gem 'rails_admin_project_builds', :path => './vendor/gems/rails_admin_project_builds/'
gem 'rails_admin_project_branch_builds', :path => './vendor/gems/rails_admin_project_branch_builds/'
gem 'rails_admin_build_project_branch', :path => './vendor/gems/rails_admin_build_project_branch/'
gem 'rails_admin_password_edit', :path => './vendor/gems/rails_admin_password_edit/'
gem 'rails_admin_invite', :path => './vendor/gems/rails_admin_invite/'
gem 'rails_admin_register_runner', path: 'vendor/gems/rails_admin_register_runner'