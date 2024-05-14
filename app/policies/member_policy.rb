# typed: true
class MemberPolicy < UserPolicy
  def permitted_attributes
    [:name, :email, :password, :password_confirmation, advertisements: []]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Member.select(:id, :name, :email).order(:created_at)
    end
  end
end
