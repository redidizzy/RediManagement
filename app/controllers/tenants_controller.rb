class TenantsController < ApplicationController 

  before_action :set_tenant

  def edit
  end

  private 

  def set_tenant
    @tenant = current_user.tenant
  end

end