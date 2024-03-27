# typed: true
class SiteController < ApplicationController
  layout "site"
  after_action :track_action

  private
  def track_action
    ahoy.track controller_path, params
  end
end
