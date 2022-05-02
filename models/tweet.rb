class Tweet < ApplicationRecord

    mount_uploader :image, ImageUploader
    validates :image, presence: true
    validates :body, presence: true
    belongs_to :user
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user
    has_many :comments, dependent: :destroy
end
