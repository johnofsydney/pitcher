class Document < ApplicationRecord
  has_many :webhooks

  def is_image?
    self.link.ends_with?('.jpg', '.jpeg', '.png', '.gif', '.avif')
  end
end
