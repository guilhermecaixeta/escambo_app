# typed: true
class Backoffice::CategoriesController::CategoryService
  extend T::Sig

  def initialize(user)
    @user = user
  end

  sig { params(params: T.untyped).returns(Category) }

  def create(params)
    @category = Category.new(params)

    if @category.valid?
      @category.save!
    end

    @category
  end

  sig { params(params: T.untyped, category: Category).returns(Category) }

  def update(params, category)
    @category = category
    @category.assign_attributes(params)

    if @category.valid?
      @category.save!
    end

    @category
  end

  def destroy(category)
    @category = category
    @category.destroy
  end
end
