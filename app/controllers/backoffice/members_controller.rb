class Backoffice::MembersController < BackofficeController
  def index
    super
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
end
