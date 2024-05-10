# typed: true
class SiteController < ApplicationController
  include ResourceConcern
  include AuthorizationConcern

  layout "site"
  after_action :track_action

  protected

  def authenticate_user
    authenticate_member!
  end

  def allow_anonymous?
    true
  end

  private

  def track_action
    if member_signed_in?
      ahoy.authenticate(current_member)
    end

    ahoy.track controller_path, params
  end
end
