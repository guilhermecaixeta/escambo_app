# typed: true
class Site::Profile::MemberProfileController < Site::ProfileController
  def initialize
    @bypass_controller_action = [{ controller: Site::Profile::MemberProfileController.controller_name,
                                   actions: [:edit, :update, :show] }]
    super
  end

  def edit
    super
  end

  def update
    super
  end

  protected

  def can_bypass_self?
    true
  end

  def default_class
    Member
  end
end
