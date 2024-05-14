# typed: true
class Backoffice::MembersController::MemberService
  extend T::Sig

  def initialize(user)
    @user = user
  end

  sig { params(params: T.untyped, member: Member).returns(Member) }

  def update(params, member)
    @member = T.let(member, T.nilable(Member))

    if @member.nil?
      raise "@member cannot be nil"
    end

    @member.assign_attributes(params)

    if @member.valid?
      @member.save!
    end

    @member
  end
end
