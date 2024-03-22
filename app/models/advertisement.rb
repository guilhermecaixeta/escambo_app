# typed: false
class Advertisement < ApplicationRecord
  extend T::Sig
  belongs_to :category
  belongs_to :user

  validates :title, :description, :category, :picture, :price, presence: true

  validates :price, numericality: { greater_than: 0.01 }

  validates :finish_date, presence: true, if: :has_valid_date?

  #Money-Rails
  monetize :price_cents

  #Active_Storage
  has_one_attached :picture

  scope :new_arrivals, ->(size = 10) { before_finish_date.limit(size).order(created_at: :desc) }
  scope :related_items, ->(id, category_id, size = 10) {
          before_finish_date
            .where("id != :id AND category_id = :category_id", { id: id, category_id: category_id })
            .limit(size)
            .order(created_at: :desc)
        }
  scope :for_member, ->(member) { where(user_id: member.id) }
  scope :before_finish_date, -> { where("finish_date >= CURRENT_DATE") }

  #Validation

  sig { returns(T::Boolean) }

  def has_valid_date?
    current_date = DateTime.now.to_date
    if finish_date.nil?
      errors.add(:finish_date, I18n.t("errors.messages.blank"))
      return false
    end
    if finish_date < current_date
      errors[:finish_date] << I18n.t("errors.messages.date_must_be_greater_than",
                                     date: I18n.l(current_date, :format => :short))
      return false
    end
    return true
  end
end
