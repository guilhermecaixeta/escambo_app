# typed: false
class Site::CommentsController < SiteController
  before_action :get_advertisement

  def new
    super

    respond_to do |format|
      format.js
    end
  end

  def create
    @object = get_default_service.create(permitted_params)

    respond_to do |format|
      if @object.valid?
        format.html {
          redirect_back fallback_location: root_path,
                        notice: t("layout.action_text.created",
                                  object_name: default_class.model_name.human,
                                  :gender => :n)
        }
      else
        flash[:alert] = "Errors to persist comment"
        format.js {
          render :new,
                 :params => { id: @advertisement.id },
                 status: :unprocessable_entity
        }
      end
    end
  end

  def edit
    super
  end

  def update
    super
  end

  def get_default_path
    :back
  end

  def get_advertisement
    @advertisement = Advertisement.find params[:id]
  end
end
