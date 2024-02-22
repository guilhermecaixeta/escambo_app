# typed: true
class AddPriceCentsToAdvertisement < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :price_cents, :integer
  end
end
