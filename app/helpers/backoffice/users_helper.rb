# typed: false
module Backoffice::UsersHelper
  # The role options
  def role_options
    Role.select(:id, :name).all
  end
end
