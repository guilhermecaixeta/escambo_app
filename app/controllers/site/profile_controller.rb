# typed: true
class Site::ProfileController < SiteController
  layout "profile"

  def allow_anonymous?
    false
  end
end
