# typed: false
module Backoffice::UsersHelper
  # The role options
  def role_options
    Role.select(:id, :name).where.not(name: Rails.configuration.default_roles.find {|r| r[:is_member]}[:name]).all
  end
end
