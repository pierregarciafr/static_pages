class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 140 }, allow_nil: false
  validates :image, content_type: { in: %w[image/jpg image/gif image/png],
                                    message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes,
                            message: 'should be less than 5 Mo' }

  def display_image
    image.variant(resize_to_limit: [250, 250])
  end
end
