# typed: strict
class Advertisement < ApplicationRecord
  belongs_to :category
  belongs_to :member

  #Money-Rails
  monetize :price_cents

  #Active_Storage
  has_one_attached :picture
end
