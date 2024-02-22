# typed: true
class BackofficeController < ApplicationController
  before_action :authenticate_user!
  before_action :user_can_read, only: [:index]
  before_action :user_can_write, only: [:new, :create, :edit, :update, :destroy]
  before_action :get_instance, only: [:edit, :update, :destroy]
  layout "backoffice"

  def policy(user)
    UserPolicy.new(user, get_controller_name)
  end

  def policy_class
    UserPolicy
  end

  protected

  def index
    @objects = policy_scope(default_class)
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
        format.json { render :index, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @object.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if get_default_service.update(permitted_params, @object)
        format.html {
          redirect_to get_default_path,
                      notice: t("layout.action_text.updated", object_name: default_class.model_name.human, :gender => :n)
        }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @object.errors, status: :unprocessable_entity }
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
        format.json { head :no_content }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @object.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_controller_name
    "backoffice"
  end

  def user_can_read
    authorize get_controller_name, :has_read_permission?, policy_class: UserPolicy
  end

  def user_can_write
    authorize get_controller_name, :has_read_and_write_permission?, policy_class: UserPolicy
  end

  def get_instance
    @object = default_class.find(params[:id])
  end

  def get_default_service
  end

  def get_default_path
  end

  def permitted_params
    permitted_attributes = policy(current_user).permitted_attributes
    params.require(controller_name.classify.underscore.to_sym).permit(permitted_attributes)
  end

  private

  def default_class
    controller_name.classify.constantize
  end
end
