# typed: true
class Backoffice::DashboardController < BackofficeController
  def index
    @most_seem_categories = Category.most_seem_categories
    @most_seem_advertisements = Advertisement.most_seem_advertisements
    respond_to do |format|
      format.js
      format.html
    end
  end

  def dashboards
  end
end
