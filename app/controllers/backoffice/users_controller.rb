# typed: false
class Backoffice::UsersController < BackofficeController
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

  def destroy
    super
  end

  protected

  def get_controller_name
    "#{super}/#{controller_name}"
  end

  def get_default_path
    backoffice_users_path
  end

  def get_default_service
    UserService
  end
end
