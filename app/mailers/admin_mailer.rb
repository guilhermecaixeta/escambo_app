# typed: strict
class AdminMailer < ApplicationMailer
  extend T::Sig

  sig { params(admin: Admin, token: String).void }

  def on_create(admin, token)
    @admin = admin
    @token = T.let(token, T.nilable(String))

    bootstrap_mail(
      to: @admin[:email],
      subject: t("layout.mailing.subject.admin_created"),
    )
  end

  sig { params(admin: Admin).returns(T.untyped) }

  def on_update(admin)
    @admin = T.let(admin, T.nilable(Admin))

    if @admin.nil?
      raise "Admin cannot be null"
    end

    bootstrap_mail(
      to: @admin[:email],
      subject: t("layout.mailing.subject.admin_updated"),
    )
  end

  sig {
    params(from_name: String,
           from_email: String,
           to_name: String,
           to_email: String,
           message: String)
      .returns(T.untyped)
  }

  def send_message_to(from_name, from_email, to_name, to_email, message)
    @to_name = T.let(to_name, T.nilable(String))
    @message = T.let(message, T.nilable(String))

    bootstrap_mail(
      from: from_email,
      to: to_email,
      subject: t("layout.mailing.subject.message_to", user_from: from_name),
    )
  end
end
