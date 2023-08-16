class Customer < ApplicationRecord
  has_many :webhooks
end
