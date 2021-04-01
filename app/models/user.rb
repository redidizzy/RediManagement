class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,:confirmable, 
         :recoverable, :rememberable, :validatable  
  after_create :skip_confirmation_notification!, unless: Proc.new { self.invitation_token.nil? }
  acts_as_tenant :tenant
  belongs_to :tenant
end
