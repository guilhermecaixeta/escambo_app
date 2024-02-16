# typed: true
class Site::HomeController < ApplicationController
  layout "site"

  def index
    @categories = Category.all.order(:id)
    @ads = Advertisement.limit(9).order(:created_at)
  end
end
