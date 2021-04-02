class WelcomeController < ApplicationController

  skip_before_action :authenticate_user!, only: [:index] 

  def index    
      @projects = current_user.projects if current_user 
  end
end
