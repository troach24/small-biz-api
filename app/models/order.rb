class Order < ApplicationRecord
  STATUSES = %w[draft submitted cancelled].freeze
  SYNC_STATUSES = %w[pending syncing synced failed].freeze

  # Model-level defaults (applied before validations)
  attribute :status, :string, default: "draft"
  attribute :sync_status, :string, default: "pending"
  attribute :currency, :string, default: "USD"
  attribute :total_cents, :integer, default: 0

  validates :customer_name, presence: true
  validates :currency, presence: true

  validates :status, inclusion: { in: STATUSES }
  validates :sync_status, inclusion: { in: SYNC_STATUSES }

  validates :total_cents,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
