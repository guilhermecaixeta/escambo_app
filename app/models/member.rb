# typed: strict
class Member < User
  # before_validation :add_default_role

  rating

  has_many :comments
  has_many :advertisements
end
