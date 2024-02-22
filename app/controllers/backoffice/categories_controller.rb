# typed: false
class Backoffice::CategoriesController < BackofficeController
  def index
    @objects = Category.order(:description)
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

  def get_default_service
    CategoryService
  end

  def get_controller_name
    "#{super}/#{controller_name}"
  end

  def permitted_params
    params.require(:category).permit(:description)
  end
end
