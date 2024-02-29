# typed: true
class AdminPolicy < UserPolicy
  extend T::Sig

  sig { returns(T::Array[T.untyped]) }

  def permitted_attributes
    [:name, :email, :password, :password_confirmation, role_ids: []]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Admin.left_outer_joins(:roles).select(:id, :name, :email).distinct.order(:name)
    end
  end
end
