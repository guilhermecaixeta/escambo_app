class Advertisement < ApplicationRecord
  belongs_to :category
  belongs_to :member
end
