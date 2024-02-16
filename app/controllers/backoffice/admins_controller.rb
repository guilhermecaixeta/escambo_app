# typed: false
class Backoffice::AdminsController < BackofficeController
  before_action :set_admin, only: [:edit, :update, :destroy]
  before_action :validate_current_admin, only: [:index, :edit, :update]

  def index
    @admins = policy_scope(Admin)
  end

  def new
    authorize Admin, :check_admin?
    @admin = Admin.new
  end

  def create
    @admin = AdminService.create(admin_params)

    respond_to do |format|
      if @admin.valid?
        format.html {
          redirect_to backoffice_admins_path,
                      notice: t("layout.action_text.created",
                                object_name: Admin.model_name.human,
                                :gender => :n)
        }
        format.json { render :index, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if AdminService.update(admin_params, @admin)
        format.html {
          redirect_to backoffice_admins_path,
                      notice: t("layout.action_text.updated", object_name: Admin.model_name.human, :gender => :n)
        }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @admin, :check_admin?
    admin_name = @admin.name

    respond_to do |format|
      if @admin.destroy
        format.html {
          redirect_to backoffice_admins_path,
                      notice: t("layout.action_text.deleted",
                                object_name: Admin.model_name.human,
                                name: admin_name,
                                :gender => :n)
        }
        format.json { head :no_content }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def validate_current_admin
    authorize Admin, :can_access?
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    permitted_attributes = policy(@admin.blank? ? Admin.new : @admin).permitted_attributes
    params.require(:admin).permit(permitted_attributes)
  end
end
