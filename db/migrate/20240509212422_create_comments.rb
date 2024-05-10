class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :title, limit: 100
      t.text :body, limit: 1000
      t.references :user, null: false, foreign_key: true
      t.references :advertisement, null: false, foreign_key: true

      t.timestamps
    end
  end
end
