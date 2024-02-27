# typed: true
class Backoffice::MembersController::MemberService
  extend T::Sig

  sig { params(params: T.untyped, member: Member).returns(Member) }

  def self.update(params, member)
    @member = member

    @member.assign_attributes(params)

    if @member.valid?
      @member.save!
    end

    @member
  end
end
