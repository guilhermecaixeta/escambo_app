class Backoffice::PermissionsController < BackofficeController
  def index
    @permissions = Permission.all
  end
end
