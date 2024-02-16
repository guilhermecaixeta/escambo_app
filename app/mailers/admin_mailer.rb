# typed: true
class AdminMailer < ApplicationMailer
  def on_update(admin)
    @admin = admin

    bootstrap_mail(
      from: :from,
      to: @admin.email,
      subject: "Seus dados foram alterados.",
    )
  end

  def send_message_to(from_name, from_email, to_name, to_email, message)
    @to_name = to_name
    @message = message

    bootstrap_mail(
      from: from_email,
      to: to_email,
      subject: t("layout.mailing.subject.message_to", user_from: from_name),
    )
  end
end
