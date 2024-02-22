# typed: true
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
      if UserPolicy.new(user, scope).has_read_and_write_permission?
        User.joins(:roles).select(:id, :name, :email).order(:id)
      else
        User.joins(:roles).select(:id, :name, :email).where("roles.name != 'member'").order(:id)
      end
    end
  end

  sig { returns(T::Boolean) }

  def has_read_permission?
    User.joins(roles: :permissions).where(
      "users.id = :id AND (roles.name = 'administrator' OR permissions.name = :controller_read OR permissions.name = :controller_write)",
      { id: user.id, controller_read: "#{record}:read", controller_write: "#{record}:write" }
    ).exists?
  end

  sig { returns(T::Boolean) }

  def has_read_and_write_permission?
    User.joins(roles: :permissions).where(
      "users.id = :id AND (roles.name = 'administrator' OR permissions.name = :controller_write)",
      { id: user.id, controller_write: "#{record}:write" }
    ).exists?
  end
end
