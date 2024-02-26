class MemberPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      User.joins(:roles).select(:id, :name, :email).where("roles.name = :member",
                                                          { member: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name] }).order(:id)
    end
  end
end
