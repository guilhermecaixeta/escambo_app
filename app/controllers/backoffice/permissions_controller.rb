class Backoffice::PermissionsController < BackofficeController
  def index
    @permissions = Permission.all
  end

  def get_controller_name
    "#{super}/#{controller_name}"
  end
end
