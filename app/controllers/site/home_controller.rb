class Site::HomeController < ApplicationController
  layout "site"

  def index
    @categories = Category.all.order(:id)
  end
end
