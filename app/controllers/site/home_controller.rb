# typed: true
class Site::HomeController < ApplicationController
  layout "site"

  def index
    @member = Member.new
    @categories = Category.all.order(:id)
    @ads = Advertisement.limit(8).order(:created_at)
  end
end
