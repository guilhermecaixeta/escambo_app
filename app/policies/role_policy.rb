class RolePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      Role.order(:name)
    end
  end
end
