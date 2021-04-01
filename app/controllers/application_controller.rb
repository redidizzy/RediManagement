class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:tenant, :subdomain)
  before_action :authenticate_user!
  before_action :redirect_to_subdomain, if: !:devise_controller?

  helper_method :current_tenant

  # def after_sign_in_path_for(resource)
   
  # end

  def subdomain_path_helper(path)
    if current_user
      request.protocol + "#{current_user.tenant.subdomain}."  + Rails.application.config.main_host + path
    else
      request.protocol + Rails.application.config.main_host + root_path
    end
  end
  def check_if_correct_subdomain?
    return ActsAsTenant.current_tenant == current_user.tenant if current_user
    Rails.application.config.main_host == request.host_with_port
  end
  def redirect_to_subdomain
    redirect_to subdomain_path_helper(request.path) if !check_if_correct_subdomain?
  end

  def current_tenant
    ActsAsTenant.current_tenant
  end
end
