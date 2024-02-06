# typed: strict
module Backoffice::AdminsHelper
  RoleOption = Struct.new(:id, :description)

  # The role options
  # @type[:id, :description]
  def options_for_role
    Admin.roles.map do |key, value|
      RoleOption.new(key, Admin.human_attribute_name("role.#{key}"))
    end
  end
end
