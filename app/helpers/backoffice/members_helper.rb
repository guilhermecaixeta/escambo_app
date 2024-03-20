# typed: true
module Backoffice::MembersHelper
  def role_options_for_members
    Role.where(name: Rails.configuration.default_roles.find { |role| role[:is_member] }[:name])
  end
end
