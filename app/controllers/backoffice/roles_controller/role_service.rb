# typed: true
class Backoffice::RolesController::RoleService
  def initialize(user)
    @user = user
  end

  def create(params)
    role = Role.new(params)

    if role.valid?
      role.save!
    end

    role
  end

  def update(params, role)
    role.assign_attributes(params)

    if role.valid?
      role.save!
    end

    role
  end

  def destroy(role)
    role.destroy
  end
end
