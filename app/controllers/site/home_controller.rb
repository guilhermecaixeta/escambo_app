# typed: true
class Site::HomeController < SiteController
  layout "site"

  def index
    @categories = Category.all.order(:id)
    @advertisements = Advertisement.new_arrivals required_params, 12
  end

  private

  def required_params
    params[:page]
  end
end
