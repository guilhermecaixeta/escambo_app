# typed: true
class CategoryPolicy < ApplicationPolicy
  def permitted_attributes
    [:description]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Category.order(:created_at)
    end
  end
end
