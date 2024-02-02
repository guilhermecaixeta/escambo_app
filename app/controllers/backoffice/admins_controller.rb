class Backoffice::AdminsController < BackofficeController
  before_action :set_admin, only: [:edit, :update, :destroy]

  def index
    @admins = if current_admin.full_access?
        Admin.all.order(:id)
      else
        Admin.filter_by_role(:restrict_access).order(:id)
      end
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html {
          redirect_to backoffice_admins_path,
          notice: t('layout.action_text.created',
                    object_name: Admin.model_name.human,
                    :gender => :n) }
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
    if params['admin']['password'].blank? && params['admin']['password_confirm'].blank?
      params['admin'].delete :password
      params['admin'].delete :password_confirmation
    end

    respond_to do |format|
      if @admin.update(admin_params)
        format.html {
          redirect_to backoffice_admins_path,
          notice: t('layout.action_text.updated', object_name: Admin.model_name.human, :gender => :n)
        }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    admin_name = @admin.name

    respond_to do |format|
      if @admin.destroy
        format.html {
          redirect_to backoffice_admins_path,
          notice: t('layout.action_text.deleted',
                    object_name: Admin.model_name.human,
                    name: admin_name,
                    :gender => :n)}
        format.json { head :no_content }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end
end
