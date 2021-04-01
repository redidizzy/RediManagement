class Tenant < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_one :user
end
