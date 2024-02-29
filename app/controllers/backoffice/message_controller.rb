# typed: false
class Backoffice::MessageController < BackofficeController
  def new
    @recipient = Admin.find(params[:message_id])
    @modal_name = "#sendMailModal"
    respond_to do |format|
      format.js
    end
  end

  def create
    message = params[:message]
    @recipient = Admin.select(:name, :email).find_by email: params[:recipient]

    message_sent = MessageService.send_message current_admin.name,
                                               current_admin.email,
                                               @recipient.name,
                                               @recipient.email,
                                               message

    if message_sent.success
      flash[:notice] = message_sent.message
      redirect_to backoffice_admins_path
    else
      flash[:alert] = message_sent.message
      respond_to do |format|
        format.js {
          render :new,
                 status: :unprocessable_entity
        }
      end
    end
  end
end
