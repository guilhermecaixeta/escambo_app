# typed: false
class UserPolicy < ApplicationPolicy
  extend T::Sig

  sig { returns(T::Boolean) }

  def can_read?
    has_read_permission?
  end

  sig { returns(T::Boolean) }

  def can_read_and_write?
    has_read_and_write_permission?
  end

  sig { returns(T::Array[T.untyped]) }

  def permitted_attributes
    [:name, :email, :password, :password_confirmation, role_ids: []]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      User.joins(:roles).select(:id, :name, :email).where("roles.name != :member",
                                                          { member: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name] }).order(:id)
    end
  end

  sig { returns(T::Boolean) }

  def has_read_permission?
    User.joins(roles: :permissions).where(
      "users.id = :id AND (roles.name = :admin_name OR permissions.name = :controller_read OR permissions.name = :controller_write)",
      { id: user.id, admin_name: get_admin_role, controller_read: "#{record}:read", controller_write: "#{record}:write" }
    ).exists?
  end

  sig { returns(T::Boolean) }

  def has_read_and_write_permission?
    User.joins(roles: :permissions).where(
      "users.id = :id AND (roles.name = :admin_name OR permissions.name = :controller_write)",
      { id: user.id, admin_name: get_admin_role, controller_write: "#{record}:write" }
    ).exists?
  end

  def get_admin_role
    Rails.configuration.default_roles.find { |r| r[:is_admin] }[:name]
  end
end
