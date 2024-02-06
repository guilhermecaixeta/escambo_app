class Backoffice::AdminsController::AdminService
  def self.create(admin_params)
    @admin = Admin.new(admin_params)

    if @admin.valid?
      @admin.save!
    end

    @admin
  end

  def self.update(admin_params, admin)
    @admin = admin
    password = admin_params["password"]
    password_confirmation = admin_params["password_confirmation"]

    if password.blank? && password_confirmation.blank?
      admin_params.delete(:password)
      admin_params.delete(:password_confirmation)
    end

    @admin.update(admin_params)
  end
end
