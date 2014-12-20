class PagesController < ApplicationController

  layout "public"
  before_action :authenticate_user!, :except => [:index]

  def help
  end

  def index
    @public_builds = Build.public_builds
  end
end
