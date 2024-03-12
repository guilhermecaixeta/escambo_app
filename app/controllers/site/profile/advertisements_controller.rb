# typed: true
# string_frozen_literal: true

class Site::Profile::AdvertisementsController < Site::ProfileController
  before_action :set_advertisement, only: [:edit, :update]

  def index
    @advertisements = Advertisement.for_member(current_member).new_arrivals
  end

  def new
    @object = Advertisement.new
  end

  def create
    @object = AdvertisementService.create(permitted_params, current_member)

    respond_to do |format|
      if @object.valid?
        format.html {
          redirect_to site_profile_advertisements_path,
                      notice: t("layout.action_text.created",
                                object_name: Advertisement.model_name.human,
                                :gender => :n)
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @object = AdvertisementService.update(permitted_params, @object)
    respond_to do |format|
      if @object.valid?
        format.html {
          redirect_to site_profile_advertisements_path,
                      notice: t("layout.action_text.updated",
                                object_name: Advertisement.model_name.human,
                                :gender => :n)
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def permitted_params
    params.require(:advertisement).permit(:id,
                                          :title,
                                          :description,
                                          :price,
                                          :category_id,
                                          :picture,
                                          :finish_date)
  end

  def set_advertisement
    @object = Advertisement.includes(:category).find(params[:id])
  end
end
