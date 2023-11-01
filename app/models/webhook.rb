class Webhook < ApplicationRecord
  belongs_to :customer
  belongs_to :document

  validates :token, uniqueness: { scope: :customer_id }
  validates :document, uniqueness: { scope: :customer_id }
end
