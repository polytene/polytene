class Ability
  include CanCan::Ability

  def initialize(user)

    if user
      can :access, :rails_admin
      can :dashboard
      can :invite

      #Runner
      can :manage, Runner, :user_id => user.id
      can :read, Runner, :is_public => true
      if user.has_role?('admin')
        can :manage, Runner
      end

      #Profile
      can [:update, :read, :history, :password_edit], Profile, :user_id => user.id
      if user.has_role?('admin')
        can :manage, Profile
      end

      #User
      if user.has_role?('admin')
        can :manage, User
      end

      #Build
      can [:read, :deploy_build, :history, :build_deployment_status, :build_project_branch, :charts, :export], Build, :project => {:user_id => user.id}
      if user.has_role?('admin')
        can :manage, Build
      end

      #Project
      can [:read, :history, :import_projects, :bulk_runners_registering, :project_builds, :export, :register_runner], [Project], :user_id => user.id
      if user.has_role?('admin')
        can :manage, Project
      end


      #ProjectBranch
      can [:manage, :history, :project_branch_builds], ProjectBranch, :project => {:user_id => user.id}
      if user.has_role?('admin')
        can :manage, ProjectBranch
      end

      #Role
      if user.has_role?('admin')
        can :manage, Role
      end

      #UserRole
      if user.has_role?('admin')
        can :manage, UserRole
      end

    end
  end
end
