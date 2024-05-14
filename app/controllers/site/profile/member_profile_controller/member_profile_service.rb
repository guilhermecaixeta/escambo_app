# typed: true
# frozen_string_literal: true

class MemberProfileService
  extend T::Sig

  def initialize(user)
    @user = user
  end

  sig { params(params: T.untyped).returns(Member) }

  def create(params)
    @member = Member.new(params)

    if @member.valid?
      @member.save!
    end

    @member
  end

  sig { params(params: T.untyped, member: Member).returns(Member) }

  def update(params, member)
    @member = member
    password = params["password"]
    password_confirmation = params["password_confirmation"]

    if password.blank? && password_confirmation.blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    @member.assign_attributes(params)

    if @member.valid?
      @member.save!
    end

    @member
  end
end
