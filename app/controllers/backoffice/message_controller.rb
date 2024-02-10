class Backoffice::MessageController < BackofficeController
  before_action :current_admin_can_send_message, only: [:new, :create]

  def new
    @admin = Admin.find(params[:message_id])

    respond_to do |format|
      format.js
    end
  end

  def create
    message = message_params[:message]
    recipient = Admin.select(:name, :email).find_by email: message_params[:recipient]

    message_sent = MessageService.send_message current_admin.name, current_admin.email, recipient.name, recipient.email, message

    if message_sent.success
      flash[:notice] = message_sent.message
    else
      flash[:alert] = message_sent.message
    end

    redirect_to backoffice_admins_path
  end

  private

  def current_admin_can_send_message
    authorize Admin, :can_access?
  end

  def message_params
    params.permit(policy(Admin).message_permitted_attributes)
  end
end
