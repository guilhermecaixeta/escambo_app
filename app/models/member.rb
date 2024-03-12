# typed: true
class Member < User
  has_many :advertisements, class_name: "Advertisements"

  validate :can_change_role?, on: :update

  define_attribute_methods

  def role_ids=(new_role_ids)
    @can_change_roles = true

    member_role = Role.find_by name: Rails.configuration.default_roles.find { |r| r[:is_member] }[:name]

    unless new_role_ids.empty?
      super [member_role.id]
      return
    end

    if new_role_ids - role_ids != 0
      @can_change_roles = false
      return
    end
  end

  private

  sig { void }

  def can_change_role?
    return if @can_change_roles

    errors.add(:roles, :member_roles_cannot_be_changed)
  end
end
