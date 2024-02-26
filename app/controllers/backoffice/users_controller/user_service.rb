# typed: true
class Backoffice::UsersController::UserService
  extend T::Sig
  sig { params(params: T.untyped).returns(User) }
  def self.create(params)
    @user = User.new(params)

    if @user.valid?
      @user.save!
    end

    @user
  end

  sig { params(params: T.untyped, user: User).returns(User) }
  def self.update(params, user)
    @user = user
    password = params["password"]
    password_confirmation = params["password_confirmation"]

    if password.blank? && password_confirmation.blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    @user.assign_attributes(params)

    if @user.valid?
      @user.save!
      UserMailer.on_update(@user).deliver_now
    end

    @user
  end
end
