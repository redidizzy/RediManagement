class Artifact < ApplicationRecord
  belongs_to :project
  acts_as_tenant :tenant
  has_one_attached :file

  MAX_FILESIZE = 10.megabytes

  validates :name, presence: true, uniqueness: true
  validates :file, attached: true, size: { less_than: 2.megabytes, message: 'Must be less than 2MB in size' }

end
