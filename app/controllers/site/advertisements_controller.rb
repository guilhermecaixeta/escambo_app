# typed: true
# frozen_string_literal: true

class Site::AdvertisementsController < SiteController
  before_action :load_advertisetment, only: [:show]
  before_action :load_related_items, only: [:show]
  before_action :load_categories, only: [:show, :search]

  def show
    respond_to do |format|
      format.html
    end
  end

  def search
    query = params[:q]
    page = params[:page]

    @advertisements = Advertisement.search_for query, page
    respond_to do |format|
      format.html
    end
  end

  private

  def load_categories
    @categories = Category.all.order(:id)
  end

  def load_advertisetment
    @advertisement = Advertisement.includes(:comments).find(params[:id])
  end

  def load_related_items
    @releated_advertisements = Advertisement.related_items(params[:id],
                                                           @advertisement.category_id,
                                                           4)
  end
end
