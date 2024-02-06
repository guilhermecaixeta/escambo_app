class AdminMailer < ApplicationMailer
  def on_update(admin)
    @admin = admin

    bootstrap_mail(from: :from, to: @admin.email, subject: "Seus dados foram alterados.")
  end
end
