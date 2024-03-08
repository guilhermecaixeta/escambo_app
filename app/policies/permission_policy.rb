# typed: true
class PermissionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      Permission.select(:id, :name).order(:name)
    end
  end
end
