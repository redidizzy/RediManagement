class WelcomeController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index] 

  def index
    @projects = Project.all if(current_user )
  end
end
