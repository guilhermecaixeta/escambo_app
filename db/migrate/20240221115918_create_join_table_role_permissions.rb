# typed: true
class CreateJoinTableRolePermissions < ActiveRecord::Migration[6.0]
  def change
    create_join_table :roles, :permissions do |t|
      t.index [:role_id, :permission_id]
    end
  end
end
