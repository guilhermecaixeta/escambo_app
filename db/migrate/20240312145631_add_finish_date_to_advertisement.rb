# typed: true
class AddFinishDateToAdvertisement < ActiveRecord::Migration[6.0]
  def change
    add_column :advertisements, :finish_date, :date
  end
end
