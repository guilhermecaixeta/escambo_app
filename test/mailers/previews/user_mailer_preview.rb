# typed: false
require "securerandom"

class UserMailerPreview < ActionMailer::Preview
  def on_create
    UserMailer.on_create(User.first, SecureRandom.uuid)
  end

  def on_update
    UserMailer.on_update(User.first)
  end

  def send_message_to
    from = User.first
    to = User.last
    UserMailer.send_message_to(from.name, from.email, to.name, to.email, "Message Test")
  end
end
