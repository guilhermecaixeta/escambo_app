class Backoffice::MembersController < BackofficeController
  def index
    @objects = MemberPolicy::Scope.new(default_class, get_controller_name).resolve()
  end

  def edit
    super
  end

  def update
    super
  end

  protected

  def get_controller_name
    "#{super}/#{controller_name}"
  end

  def get_default_path
    backoffice_members_path
  end

  def get_default_service
    MemberService
  end

  def default_class
    User
  end
end
