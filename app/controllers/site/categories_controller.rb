class Site::CategoriesController < SiteController
  def advertisements
    @categories = Category.all.order(:description)
    @category_description = params[:category_description]
    @ads = Advertisement.by_category_description(@category_description)
  end
end
