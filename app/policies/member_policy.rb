class MemberPolicy < UserPolicy
  def permitted_attributes
    [:name, :email, role_ids: []]
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      Member.joins(:roles).select(:id, :name, :email).where("roles.name = :member",
                                                            { member: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name] }).order(:id)
    end
  end
end
