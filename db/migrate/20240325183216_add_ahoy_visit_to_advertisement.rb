# typed: true
class AddAhoyVisitToAdvertisement < ActiveRecord::Migration[6.0]
  def change
    add_reference :advertisements, :ahoy_visit
  end
end
