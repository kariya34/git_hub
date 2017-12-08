class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :user_id, presence: true, exclusion: { in: %w(\  　) }, length: { maximum: 255 }, \
    format: { with: VALID_EMAIL_REGEX }
  with_options on: :save? do
    validates :user_id, uniqueness: true
  end
  validates :password, presence: true, exclusion: { in: %w(\  　) }, length: { maximum: 255 }
end
