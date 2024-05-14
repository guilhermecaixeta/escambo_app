# typed: true
class CommentPolicy < ApplicationPolicy
  def permitted_attributes
    [:body, :title, :advertisement_id, member: [:rating]]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
    end
  end
end
