# typed: false
class Backoffice::CategoriesController < BackofficeController
  before_action :set_category, only: [:edit, :update]

  def index
    @categories = Category.all.order(:id)
  end

  def new
    @category = Category.new
  end

  def create
    @category = CategoryService.create(category_params)

    respond_to do |format|
      if @category.valid?
        format.html {
          redirect_to backoffice_categories_path,
                      notice: t("layout.action_text.created", object_name: Category.model_name.human, :gender => :f)
        }
        format.json { render :index, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html {
          redirect_to backoffice_categories_path,
                      notice: t("layout.action_text.updated", object_name: Category.model_name.human, :gender => :f)
        }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:description)
  end
end
