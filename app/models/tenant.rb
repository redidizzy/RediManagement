class Tenant < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_one :user

  has_one :payment

  accepts_nested_attributes_for :payment

  def can_create_project? 
    self.plan == "premium" or Project.count < 1
  end
end
