# typed: true
class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table(:roles) do |t|
      t.string :name, limit: 255, null: false

      t.timestamps
    end

    create_table(:users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:users_roles, [:user_id, :role_id])
  end
end
