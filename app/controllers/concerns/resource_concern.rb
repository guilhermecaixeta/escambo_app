module ResourceConcern
  extend ActiveSupport::Concern

  included do
    before_action :get_instance, only: [:edit, :update, :destroy]
    before_action :get_page, only: [:index]

    protected

    def index
      @objects = "#{default_class_name}Policy::Scope".constantize.new(default_class, get_controller_name).resolve()
    end

    def new
      @object = default_class.new
    end

    def create
      @object = get_default_service.create(permitted_params)

      respond_to do |format|
        if @object.valid?
          format.html {
            redirect_to get_default_path,
                        notice: t("layout.action_text.created",
                                  object_name: default_class.model_name.human,
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
      respond_to do |format|
        if get_default_service.update(permitted_params, @object).valid?
          format.html {
            redirect_to get_default_path,
                        notice: t("layout.action_text.updated", object_name: default_class.model_name.human, :gender => :n)
          }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      default_name = @object.name

      respond_to do |format|
        if @object.destroy
          format.html {
            redirect_to get_default_path,
                        notice: t("layout.action_text.deleted",
                                  object_name: default_class.model_name.human,
                                  name: default_name,
                                  :gender => :n)
          }
        else
          format.html { render :index, status: :unprocessable_entity }
        end
      end
    end

    def get_default_path
    end

    private

    def get_controller_name
      controller_path
    end

    def get_page
      @page = params[:page]
    end

    def get_instance
      @object = default_class.find(params[:id])
    end

    def get_default_service
      "#{controller_path.camelize}Controller::#{default_class_name}Service".constantize.new current_user
    end

    def permitted_params
      permitted_attributes = get_current_class_policy.new(default_class, get_controller_name).permitted_attributes
      params.require(default_class_name.underscore.to_sym).permit(permitted_attributes)
    end

    def default_class
      default_class_name.constantize
    end

    def get_current_class_policy
      "#{default_class_name}Policy".constantize
    end

    def default_class_name
      controller_name.classify
    end
  end
end
