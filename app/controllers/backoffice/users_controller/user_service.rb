# typed: true
class Backoffice::UsersController::UserService
  extend T::Sig
  sig { params(params: User).returns(User) }
  def self.create(params)
    @user = User.new(params)

    if @user.valid?
      @user.save!
    end

    @user
  end

  sig { params(params: T.untyped, user: User).returns(T::Boolean) }
  def self.update(params, user)
    @user = user
    password = params["password"]
    password_confirmation = params["password_confirmation"]

    if password.blank? && password_confirmation.blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = @user.update(params)
    UserMailer.on_update(@user).deliver_now
    return result
  end
end
