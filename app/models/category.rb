# typed: strict

class Category < ApplicationRecord
  has_many :advertisements
  validates_presence_of :description

  scope :most_seem_categories, -> {
          query = <<~EOL
            properties @> '{\"action\": \"show\", \"controller\": \"site/advertisements\"}'
            AND advertisements.finish_date >= CURRENT_DATE
          EOL
          where(query)
            .joins("JOIN advertisements ON advertisements.category_id = categories.id")
            .joins("JOIN \"ahoy_events\" ON (\"ahoy_events\".properties->>'id')::INT = advertisements.id")
            .joins("JOIN \"ahoy_visits\" ON \"ahoy_visits\".id = \"ahoy_events\".visit_id")
            .select("categories.description as category_description", "COUNT(category_id) as total_accesses")
            .group("categories.description")
        }
  scope :most_seem_categories_for_user, ->(user_id) {
          query = <<~EOL
            properties @> '{\"action\": \"show\", \"controller\": \"site/advertisements\"}'
            AND advertisements.finish_date >= CURRENT_DATE
            AND advertisements.user_id = :user_id
          EOL
          where(query, { user_id: user_id })
            .joins("JOIN advertisements ON advertisements.category_id = categories.id")
            .joins("JOIN \"ahoy_events\" ON (\"ahoy_events\".properties->>'id')::INT = advertisements.id")
            .joins("JOIN \"ahoy_visits\" ON \"ahoy_visits\".id = \"ahoy_events\".visit_id")
            .select("categories.description as category_description", "COUNT(category_id) as total_accesses")
            .group("categories.description")
        }
end
