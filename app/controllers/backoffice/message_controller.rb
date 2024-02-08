class Backoffice::MessageController < ApplicationController
  def new
    @admin = Admin.find(params[:message_id])

    respond_to do |format|
      format.js
    end
  end

  def create
    @current_admin = current_admin
    @message = message_params[:message]
    @recipient = Admin.find_by email: message_params[:recipient]

    AdminMailer.send_message_to(@current_admin, @recipient, @message).deliver_now

    redirect_to backoffice_admins_path, flash: { notice: "Mensagem enviada com sucesso!" }
  end

  private

  def message_params
    params.permit(:recipient, :message)
  end
end
