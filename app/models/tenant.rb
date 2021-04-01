class Tenant < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_one :user

  def can_create_project? 
    self.plan == "premium" or Project.count < 1
  end
end
