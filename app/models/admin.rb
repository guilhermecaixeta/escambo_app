class Admin < ApplicationRecord
  enum role: [:full_access, :restrict_access]

  scope :filter_by_role, -> (role) { where(role: role) if role.present? }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
