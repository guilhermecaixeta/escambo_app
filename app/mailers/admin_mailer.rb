class AdminMailer < ApplicationMailer
  def on_update(admin)
    @admin = admin

    bootstrap_mail(
      from: :from,
      to: @admin.email,
      subject: "Seus dados foram alterados.")
  end

  def send_message_to(current_admin, recipient, message)
    @current_admin = current_admin
    @recipient = recipient
    @message = message

    bootstrap_mail(
      from: @current_admin.email,
      to: @recipient,
      subject: t('layout.mailing.subject.message_to', user_from: @current_admin.name))
  end
end
