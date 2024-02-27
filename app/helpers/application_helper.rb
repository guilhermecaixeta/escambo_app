# typed: strict
module ApplicationHelper
extend T::Sig

sig { params(user: User, controller_name: String).returns(UserPolicy) }
  def policy_for(user, controller_name)
    UserPolicy.new(user, controller_name)
  end
end
