# typed: true
class Backoffice::MembersController::MemberService
  extend T::Sig

  sig { params(params: T::Array[Symbol], member: User).returns(User) }

  def update(params, member)
    @member = member

    params.delete(:password)
    params.delete(:password_confirmation)

    @member.assign_attributes(params)

    if @member.valid?
      @member.save!
    end

    @member
  end
end
