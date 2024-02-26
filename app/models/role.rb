# typed: false
class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  has_and_belongs_to_many :permissions, :join_table => "permissions_roles"

  before_validation :has_default_role_changed?, on: :update

  validates :name, uniqueness: true, presence: true, length: { minimum: 2 }

  def has_default_role_changed?
    name = name_before_last_save
    if Rails.configuration.default_roles.any? { |r| r[:name] == name }
      self.errors[:base] << I18n.t("errors.messages.default_roles")
    end
  end
end
