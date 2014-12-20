RailsAdmin.config do |config|

  ### Popular gems integration

  config.main_app_name = ["Polytene", "Continuous Deployment"]

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  
  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  RailsAdmin.config {|c| c.label_methods << :name}
  RailsAdmin.config {|c| c.label_methods << :full_name}
  RailsAdmin.config {|c| c.label_methods << :long_name}
  RailsAdmin.config {|c| c.label_methods << :email}
  RailsAdmin.config {|c| c.label_methods << :ref}
  RailsAdmin.config {|c| c.label_methods << :branch_name}
  RailsAdmin.config {|c| c.label_methods << :gitlab_ci_name}

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    import_projects
    deploy_build
    build_deployment_status
    bulk_runners_registering
    project_builds
    project_branch_builds
    build_project_branch
    password_edit
    register_runner

    charts
    invite

    ## With an audit adapter, you can add:
    history_index
    history_show
  end
end
