class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { maximum: 15 }
  validates :description, length: { maximum: 200 }

  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  # validates :password, presence: true, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,32}+\z/i }

  validates :password, presence: true, length: { minimum: 6, maximum: 15 }, :on => :create
  mount_uploader :image, ImageUploader

  has_many :topics
  has_many :favorites
  has_many :favorite_topics, through: :favorites, source: 'topic'

end
