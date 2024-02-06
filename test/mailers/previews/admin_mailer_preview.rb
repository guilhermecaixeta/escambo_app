class AdminMailerPreview < ActionMailer::Preview
  def on_update
    AdminMailer.on_update(Admin.first)
  end
end
