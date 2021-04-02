module ApplicationHelper

  def class_name_for_tenant_form (tenant) 
    return "cc-form" if tenant.payment.blank?
    ""
  end
end
