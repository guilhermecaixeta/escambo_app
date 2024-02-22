# typed: true
class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :name, limit: 255, null: false

      t.timestamps
    end
  end
end
