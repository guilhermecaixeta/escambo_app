# typed: true
class Backoffice::DashboardController < BackofficeController
  def index
  end

  def get_controller_name
    "#{super}/#{controller_name}"
  end
end
