# typed: false
class Backoffice::CategoriesController < BackofficeController
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
    backoffice_categories_path
  end

  def permitted_params
    params.require(:category).permit()
  end
end
