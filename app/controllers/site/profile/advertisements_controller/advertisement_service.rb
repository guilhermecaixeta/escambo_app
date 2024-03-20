# typed: strict
# string_frozen_literal: true

class Site::Profile::AdvertisementsController::AdvertisementService
  extend T::Sig

  sig { params(params: T.untyped, current_member: Member).returns(Advertisement) }
  def self.create(params, current_member)
    @advertisement = T.let(Advertisement.new(params), T.nilable(Advertisement))

    if @advertisement.nil?
      fail "Cannot create an advertisement with the informed params"
    end

    @advertisement.user = current_member

    if @advertisement.valid?
      @advertisement.save!
    end

    @advertisement
  end

  sig { params(params: T.untyped, advertisement: Advertisement).returns(Advertisement) }
  def self.update(params, advertisement)
    @advertisement = T.let(advertisement, T.nilable(Advertisement))

    if @advertisement.nil?
      fail "Cannot create an advertisement with the informed params"
    end

    @advertisement.assign_attributes(params)

    if @advertisement.valid?
      @advertisement.save!
    end

    @advertisement
  end
end
