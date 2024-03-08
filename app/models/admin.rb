# typed: false
class Admin < User
  def send_message_on_create
    token = set_reset_password_token
    UserMailer.on_create(self, token).deliver_now
  end
end
