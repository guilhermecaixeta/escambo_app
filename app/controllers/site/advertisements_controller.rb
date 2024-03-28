# typed: true
# frozen_string_literal: true

class Site::AdvertisementsController < SiteController
  before_action :load_advertisetment, only: [:show]

  def show
    @releated_advertisements = Advertisement.related_items(params[:id],
                                                           @advertisement.category_id,
                                                           6)
    respond_to do |format|
      format.js
    end
  end

  private

  def load_advertisetment
    @advertisement = Advertisement.find(params[:id])
  end
end
