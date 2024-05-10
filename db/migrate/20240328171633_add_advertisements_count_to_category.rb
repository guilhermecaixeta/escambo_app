# typed: true
class AddAdvertisementsCountToCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :advertisements_count, :integer, default: 0
  end
end
