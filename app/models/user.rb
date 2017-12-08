class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :user_id, presence: true, exclusion: { in: %w(\  　) }, length: { maximum: 255 }, \
    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, exclusion: { in: %w(\  　) }, length: { maximum: 255 }
end
