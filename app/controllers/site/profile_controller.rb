# typed: true
class Site::ProfileController < SiteController
  before_action :authenticate_member!
  before_action :user_can_read, only: [:index]
  before_action :user_can_write, only: [:new, :create, :edit, :update, :destroy]

  layout "profile"

  def pundit_user
    current_member
  end

  def policy(user)
    UserPolicy.new(user, controller_path)
  end

  private

  def user_can_read
    authorize controller_path, :has_read_permission?, policy_class: UserPolicy
  end

  def user_can_write
    authorize controller_path, :has_read_and_write_permission?, policy_class: UserPolicy
  end
end
