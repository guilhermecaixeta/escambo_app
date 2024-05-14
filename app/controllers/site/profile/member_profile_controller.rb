# typed: true
class Site::Profile::MemberProfileController < Site::ProfileController
  def initialize
    @bypass_controller_action = [{ controller: Site::Profile::MemberProfileController.controller_name,
                                   actions: [:edit, :update, :show] }]
    super
  end

  def can_bypass_self?
    true
  end

  def show
  end

  def edit
  end

  def update
  end
end
