class AddPlanToTenants < ActiveRecord::Migration[6.1]
  def change
    add_column :tenants, :plan, :string
  end
end
