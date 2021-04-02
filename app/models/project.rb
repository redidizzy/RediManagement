class Project < ApplicationRecord
  acts_as_tenant :tenant

  validates_uniqueness_of :title
  validate :free_plan_can_only_have_one_project

  has_many :artifacts, dependent: :destroy

  has_many :user_projects
  has_many :users, through: :user_projects


  def free_plan_can_only_have_one_project
    if self.new_record? and ActsAsTenant.current_tenant.plan == 'free' and Project.count > 0
      errors.add(:base, "Free plans cannot have more than one project")
    end
  end

end
