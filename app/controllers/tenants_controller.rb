class TenantsController < ApplicationController 

  before_action :set_tenant
  before_action :verify_if_admin

  def edit
  end

  def update 
    respond_to do |format|
      Tenant.transaction do 
        if @tenant.update(tenant_params)
          if @tenant.plan == 'premium' and @tenant.payment.blank?
            @payment = Payment.new(email: tenant_params[:email], token: params[:payment][:token], tenant: @tenant)
            begin
              @payment.process_payment
              @payment.save
              
            rescue Exception => e 
              flash[:alert] = e.message 
              @payment.destroy
              @tenant.plan = 'free'
              @tenant.save
              redirect_to edit_tenant_path(@tenant) and return
            end
          end
          format.html { redirect_to edit_plan_path, notice: "Plan was successfully updated"}
        else
          format.html { render "edit" }
        end
      end
    end
  end

  private 

  def set_tenant
    @tenant = current_user.tenant
  end

  def tenant_params 
    params.require(:tenant).permit(:name, :plan)
  end

end