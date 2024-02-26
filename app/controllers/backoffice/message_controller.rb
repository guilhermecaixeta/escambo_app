# typed: false
class Backoffice::MessageController < BackofficeController
  def new
    @user = User.find(params[:message_id])

    respond_to do |format|
      format.js
    end
  end

  def create
    message = message_params[:message]
    recipient = User.select(:name, :email).find_by email: message_params[:recipient]

    message_sent = MessageService.send_message current_user.name, current_user.email, recipient.name, recipient.email, message

    if message_sent.success
      flash[:notice] = message_sent.message
    else
      flash[:alert] = message_sent.message
    end

    redirect_to backoffice_admins_path
  end

  def get_controller_name
    "#{super}/#{controller_name}"
  end

  private

  def message_params
    params.permit(MessagePolicy.new(current_user, get_controller_name).permitted_attributes)
  end
end
