# typed: false
class Advertisement < ApplicationRecord
  extend T::Sig
  SEARCH_ATTRIBUTES = %i[title description]

  rating
  has_many :comments
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

  scope :search_for, ->(query, page, size = 10) {
          sql_query = SEARCH_ATTRIBUTES.map { |att| "#{att} ~~* '%#{query}%'" }.join " OR "
          before_finish_date.where(sql_query).order_by_rating({ column: :estimate, direction: :asc }).paginate(page, size)
        }

  scope :new_arrivals, ->(page, size = 10) {
          before_finish_date.limit(size).order_by_rating({ column: :estimate, direction: :asc }).paginate(page, size)
        }

  scope :related_items, ->(id, category_id, page = 0, size = 10) {
          before_finish_date
            .where("advertisements.id != :id AND category_id = :category_id",
                   { id: id, category_id: category_id }).limit(size)
            .order_by_rating({ column: :estimate, direction: :asc })
            .paginate(page, size)
        }

  scope :by_category_description, ->(category_description, page, size = 10) {
          before_finish_date
            .joins("JOIN categories on categories.id = category_id")
            .where("categories.description = :category_description", { category_description: category_description })
            .order_by_rating({ column: :estimate, direction: :asc })
            .paginate(page, size)
        }

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

  scope :for_member, ->(member) { where(user_id: member.id) }
  scope :before_finish_date, -> { where("finish_date >= CURRENT_DATE") }
  scope :paginate, ->(page, size = 10) { page(page).per(size) }
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
