# typed: false
module Backoffice::UsersHelper
  # The role options
  def options_for_role
    Role.select(:id, :name).all
  end
end
