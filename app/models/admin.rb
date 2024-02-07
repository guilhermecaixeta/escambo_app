# typed: strict
class Admin < ApplicationRecord
  enum role: [:full_access, :restrict_access]

  validates_presence_of :name
  validates :role, presence: true, on: :create

  # Filter users by role.
  scope :filter_by_role, ->(role) { where(role: role) if role.present? }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
