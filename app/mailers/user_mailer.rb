# typed: true
class UserMailer < ApplicationMailer
  extend T::Sig

  sig { params(user: User, token: String).void }

  def on_create(user, token)
    @user = user
    @token = T.let(token, T.nilable(String))

    bootstrap_mail(
      to: @user[:email],
      subject: t("layout.mailing.subject.user_created"),
    )
  end

  sig { params(user: User).returns(T.untyped) }

  def on_update(user)
    @user = T.let(user, T.nilable(User))

    if @user.nil?
      raise "User cannot be null"
    end

    bootstrap_mail(
      to: @user[:email],
      subject: t("layout.mailing.subject.user_updated"),
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
