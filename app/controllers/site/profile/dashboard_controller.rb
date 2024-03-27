# typed: true
class Site::Profile::DashboardController < Site::ProfileController
  def index
    @most_seem_categories = Category.most_seem_categories_for_user(current_member.id)
    @most_seem_advertisements = Advertisement.most_seem_advertisements_for_user(current_member.id)
    respond_to do |format|
      format.js
    end
  end
end
