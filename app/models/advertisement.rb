# typed: false
class Advertisement < ApplicationRecord
  extend T::Sig
  belongs_to :category, counter_cache: :advertisements_count
  belongs_to :user
  visitable :ahoy_visit

  validates :title, :description, :category, :picture, :price, presence: true

  validates :price, numericality: { greater_than: 0.01 }

  validates :finish_date, presence: true, if: :has_valid_date?

  #Money-Rails
  monetize :price_cents

  #Active_Storage
  has_one_attached :picture

  scope :new_arrivals, ->(size = 10) { before_finish_date.limit(size).order(created_at: :desc) }
  scope :by_category_description, ->(category_description, size = 10) {
          before_finish_date
            .joins("JOIN categories on categories.id = category_id")
            .where("categories.description = :category_description", { category_description: category_description })
            .limit(size)
            .order(created_at: :desc)
        }
  scope :related_items, ->(id, category_id, size = 10) {
          before_finish_date
            .where("id != :id AND category_id = :category_id", { id: id, category_id: category_id })
            .limit(size)
            .order(created_at: :desc)
        }
  scope :for_member, ->(member) { where(user_id: member.id) }
  scope :before_finish_date, -> { where("finish_date >= CURRENT_DATE") }
  scope :most_seem_advertisements, -> {
          query = <<~EOL
            \"ahoy_events\".properties @> '{\"action\": \"show\", \"controller\": \"site/advertisements\"}'
            AND advertisements.finish_date >= CURRENT_DATE
          EOL
          where(query)
            .joins("JOIN \"ahoy_events\" ON (\"ahoy_events\".properties->>'id')::INT = advertisements.id")
            .joins("JOIN \"ahoy_visits\" ON \"ahoy_visits\".id = \"ahoy_events\".visit_id")
            .select("advertisements.title as advertisement_title", "COUNT(advertisements.id) as total_accesses")
            .group("advertisements.title")
        }
  scope :most_seem_advertisements_for_user, ->(user_id) {
          query = <<~EOL
            \"ahoy_events\".properties @> '{\"action\": \"show\", \"controller\": \"site/advertisements\"}'
            AND advertisements.finish_date >= CURRENT_DATE
            AND advertisements.user_id = :user_id
          EOL
          where(query, { user_id: user_id })
            .joins("JOIN \"ahoy_events\" ON (\"ahoy_events\".properties->>'id')::INT = advertisements.id")
            .joins("JOIN \"ahoy_visits\" ON \"ahoy_visits\".id = \"ahoy_events\".visit_id")
            .select("advertisements.title as advertisement_title", "COUNT(advertisements.id) as total_accesses")
            .group("advertisements.title")
        }

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
