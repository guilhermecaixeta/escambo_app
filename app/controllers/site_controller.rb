# typed: true
class SiteController < ApplicationController
  layout "site"
  after_action :track_action

  private

  def track_action
    if member_signed_in?
      ahoy.authenticate(current_member)
    end

    ahoy.track controller_path, params
  end
end
