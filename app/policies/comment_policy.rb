class CommentPolicy < ApplicationPolicy
  def permitted_attributes
    [:body, :title, :advertisement_id]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
    end
  end
end
