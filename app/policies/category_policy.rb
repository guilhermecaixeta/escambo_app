class CategoryPolicy < ApplicationPolicy
  def permitted_params
    [:description]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Category.order(:description)
    end
  end
end
