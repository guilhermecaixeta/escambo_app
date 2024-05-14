# typed: false
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :user
      "custom_devise"
    else
      "application"
    end
  end
end
