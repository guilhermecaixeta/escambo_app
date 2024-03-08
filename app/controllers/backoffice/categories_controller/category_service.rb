# typed: true
class Backoffice::CategoriesController::CategoryService
  extend T::Sig

  attr_accessor :category

  sig { params(params: T.untyped).returns(Category) }
  def self.create(params)
    category = Category.new(params)

    if category.valid?
      category.save!
    end

    category
  end

  sig { params(params: T.untyped, category: Category).returns(Category) }
  def self.update(params, category)
    category.assign_attributes(params)

    if category.valid?
      category.save!
    end

    category
  end

  def self.destroy(category)
    category.destroy
  end
end
