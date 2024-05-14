# typed: true
module ApplicationHelper
  def policy_for(user, controller_name)
    UserPolicy.new(user, controller_name)
  end
end
