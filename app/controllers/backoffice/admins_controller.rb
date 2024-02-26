# typed: false
class Backoffice::AdminsController < BackofficeController
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
    backoffice_admins_path
  end
end
