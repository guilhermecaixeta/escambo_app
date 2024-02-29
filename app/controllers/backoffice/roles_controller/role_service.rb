# typed: true
class Backoffice::RolesController::RoleService
  def self.create(params)
    role = Role.new(params)

    if role.valid?
      role.save!
    end

    role
  end

  def self.update(params, role)
    role.assign_attributes(params)

    if role.valid?
      role.save!
    end

    role
  end

  def self.destroy(role)
    role.destroy
  end
end
