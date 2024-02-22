class Backoffice::RolesController < BackofficeController
  def index
    super
  end

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  protected

  def get_default_path
    backoffice_roles_path
  end

  def get_default_service
    RoleService
  end

  def get_controller_name
    "#{super}/#{controller_name}"
  end
end
