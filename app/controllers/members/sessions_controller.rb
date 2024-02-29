# typed: true
# frozen_string_literal: true

class Members::SessionsController < Devise::SessionsController
  # GET /resource/sign_in
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_with(resource, serialize_options(resource)) do |format|
      format.js
    end
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)
    unless self.resource.nil?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      self.resource = resource_class.new(sign_in_params)
      flash[:alert] = [t("devise.failure.#{warden.message.nil? ? "invalid" : warden.message}",
                         authentication_keys: "email")]
      respond_to do |format|
        format.js { render :new, status: :unauthorized }
      end
    end
  end
end
