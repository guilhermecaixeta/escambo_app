class AdminPolicy < ApplicationPolicy
  def check_admin?
    user.full_access?
  end

  def check_restrict?
    user.restrict_access?
  end

  def can_access
    user.full_access? or user.restrict_access?
  end

  def permitted_attributes
    if user.full_access?
      [:name, :email, :password, :password_confirmation, :role]
    else
      [:name, :email, :password, :password_confirmation]
    end
  end

  class Scope < Scope
    def resolve
      if user.full_access?
        Admin.filter_by_role(nil).order(:id)
      else
        Admin.filter_by_role(:restrict_access).order(:id)
      end
    end
  end
end
