class RolePolicy < ApplicationPolicy
  def permitted_attributes
    [:name, permission_ids: []]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Role.order(:name)
    end
  end
end
