class SitePage < ApplicationRecord
  validates :page_key,
            presence: true,
            uniqueness: true,
            inclusion: { in: %w[about contact] }

  validates :title,
            presence: true,
            length: { maximum: 100 }

  validates :content,
            presence: true
end