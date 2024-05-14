# typed: true
# string_frozen_literal: true

class BackofficeController < ApplicationController
  include AuthorizationConcern
  include ResourceConcern

  layout "backoffice"

  protected

  def authenticate_user
    authenticate_admin!
  end
end
