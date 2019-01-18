class Topic < ApplicationRecord
  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: 1000 }
  validates :image, presence: true
  belongs_to :user
  mount_uploader :image, ImageUploader
  has_many :favorites
  has_many :favorite_users, through: :favorites, source: 'user'
end
