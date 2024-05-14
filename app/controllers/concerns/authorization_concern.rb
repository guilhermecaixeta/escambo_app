# typed: false
module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user, unless: :allow_anonymous?
    before_action :user_can_read?, only: [:index, :show], unless: :allow_anonymous?
    before_action :user_can_write?, only: [:new, :create, :edit, :update, :destroy]
    before_action :store_user_location!, if: :storable_location?
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def policy(user)
      UserPolicy.new(user, controller_path)
    end

    def pundit_user
      current_user
    end

    protected

    @bypass_controller_action = []

    def can_bypass_self?
      false
    end

    def user_can_read?
      unless can_bypass_self?
        authorize get_controller_name, :has_read_permission?, policy_class: UserPolicy
      else
        authorize_bypass?
      end
    end

    def user_can_write?
      unless can_bypass_self?
        authorize get_controller_name, :has_read_and_write_permission?, policy_class: UserPolicy
      else
        authorize_bypass?
      end
    end

    def current_user
      if admin_signed_in?
        current_admin
      elsif member_signed_in?
        current_member
      end
    end

    def authenticate_user
    end

    def allow_anonymous?
      false
    end

    def user_not_authorized
      flash[:alert] = t "layout.action_text.not_authorized"
      redirect_back(fallback_location: root_path)
    end

    private

    def authorize_bypass?
      @bypass_controller_action.any? do |ca|
        ca[:controller] == controller_name &&
        ca[:actions].any? do |action|
          action.to_s == action_name
        end
      end &&
      current_user.id == params[:id].to_i
    end

    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      user = admin_signed_in? ? :admin : :member

      store_location_for(user, request.fullpath)
    end
  end
end
