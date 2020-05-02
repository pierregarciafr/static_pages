class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }, allow_nil: false

end
