module AuthorizationConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user, unless: :allow_anonymous?
    before_action :user_can_read, only: [:index, :show], unless: :allow_anonymous?
    before_action :user_can_write, only: [:new, :create, :edit, :update, :destroy]
    before_action :store_user_location!, if: :storable_location?

    def policy(user)
      UserPolicy.new(user, controller_path)
    end

    def pundit_user
      current_user
    end

    def user_can_read
      authorize get_controller_name, :has_read_permission?, policy_class: UserPolicy
    end

    def user_can_write
      authorize get_controller_name, :has_read_and_write_permission?, policy_class: UserPolicy
    end

    protected

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

    private

    def storable_location?
      request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
    end

    def store_user_location!
      user = admin_signed_in? ? :admin : :member

      store_location_for(user, request.fullpath)
    end
  end
end
