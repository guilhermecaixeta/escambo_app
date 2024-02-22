# typed: false
class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  has_and_belongs_to_many :permissions, :join_table => "permissions_roles"

  before_validation :has_name_changed?, on: :update

  validates :name, uniqueness: true, presence: true, length: { minimum: 2 }

  def has_name_changed?
    if id <= 3 and will_save_change_to_name?
      self.errors[:base] << I18n.t("errors.validation.default_roles")
    end
  end
end
