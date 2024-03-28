class Site::CategoriesController < SiteController
  def advertisements
    @categories = Category.all.order(:id)
    @category_description = params[:category_description]
    @ads = Advertisement.by_category_description(params[:category_description])
  end
end
