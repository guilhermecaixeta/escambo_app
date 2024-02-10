class AdminPolicy < ApplicationPolicy
  def check_admin?
    user.full_access?
  end

  def can_access?
    user.full_access? or user.restrict_access?
  end

  def message_permitted_attributes
    [:authenticity_token, :commit, :recipient, :message]
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
      role = if user.full_access?
          nil
        else
          :restrict_access
        end

      Admin.select(:id, :name, :email, :role).filter_by_role(role).order(:id)
    end
  end
end
