# typed: true
class Backoffice::AdminsController::AdminService
  extend T::Sig
  sig { params(params: T.untyped).returns(Admin) }
  def self.create(params)
    @admin = Admin.new(params)

    if @admin.valid?
      @admin.save!
    end

    @admin
  end

  sig { params(params: T.untyped, admin: Admin).returns(Admin) }
  def self.update(params, admin)
    @admin = admin
    password = params["password"]
    password_confirmation = params["password_confirmation"]

    if password.blank? && password_confirmation.blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    @admin.assign_attributes(params)

    if @admin.valid?
      @admin.save!
      AdminMailer.on_update(@admin).deliver_now
    end

    @admin
  end
end
