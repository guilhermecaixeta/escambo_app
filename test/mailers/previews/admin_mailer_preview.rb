class AdminMailerPreview < ActionMailer::Preview
  def on_update
    AdminMailer.on_update(Admin.first)
  end

  def send_message_to
    AdminMailer.send_message_to(Admin.first, Admin.last, "Message Test")
  end
end
