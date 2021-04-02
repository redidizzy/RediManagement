# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    tenant = Tenant.new(sign_up_tenant_params.merge(subdomain: sign_up_tenant_params[:name].parameterize))
    byebug
    if(tenant.plan == 'premium') 
      @payment = Payment.new ({ email: sign_up_params[:email], token: params[:payment][:token] })
      flash[:error] = "Please check registration errors." unless @payment.valid?

      begin 
        @payment.process_payment
        @payment.save
        tenant.payment = @payment 
        tenant.save
      rescue Exception => e 
        flash[:error] = e.message
        tenant.destroy
        puts "Payment failed"
        redirect_to new_user_registration_path and return
      end
    else 
      tenant.save
    end
    
    build_resource(sign_up_params.merge(tenant: tenant))
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
    
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:tenant => [:name, :plan]])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def sign_up_params    
    params.require(:user).permit(:email, :password, :password_confirmation, tenant: [:name, :plan])
  end
  def sign_up_tenant_params    
    params.require(:tenant).permit(:name, :plan)
  end

end
