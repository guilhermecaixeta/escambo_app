# typed: true
class Site::HomeController < SiteController
  layout "site"

  def index
    @categories = Category.all.order(:id)
    @ads = Advertisement.new_arrivals(12)
  end
end
