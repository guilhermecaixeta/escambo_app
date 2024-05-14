# typed: true
class Site::ProfileController < SiteController
  layout "profile"

  protected

  def allow_anonymous?
    false
  end
end
