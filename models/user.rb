class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
          has_many :tweets, dependent: :destroy
          has_many :reviews
          validates :name, presence: true
          validates :profile, length: { maximum: 200 }
          validates :email, uniqueness: true, presence: true, 
          format:{ with: /[A=za-z0-9]+@[a-z\d\-.]{0,9}(fukuoka|keio|waseda|fukuoka|kobe|shubun|tohoku-gakuin|sugiyama|kamakura|nitech|gifu|kobe|meijo|nuas|sophia|aichi|kinjo|tus|kanazawa|fukuyama|nagoya|nanzan|chukyo|mie|ngu|obirin|tokai|nihon)[a-z\d\-.]+/}
          has_many :likes, dependent: :destroy
          has_many :liked_tweets, through: :likes, source: :tweet
          has_many :relationships, foreign_key: "user_id",dependent: :destroy
          has_many :followings, through: :relationships, source: :follow
          has_many :passive_relationships, class_name: "Relationship",foreign_key: "follow_id",dependent: :destroy
          has_many :followers, through: :passive_relationships, source: :user
          
          def follow(other_user)
            unless self == other_user
              self.relationships.find_or_create_by(follow_id: other_user.id)
            end
          end
        
          def unfollow(other_user)
            relationship = self.relationships.find_by(follow_id: other_user.id)
            relationship.destroy if relationship
          end
        
          def following?(other_user)
            self.followings.include?(other_user)
          end
          
          mount_uploader :image, ImageUploader
          def already_liked?(tweet)
            self.likes.exists?(tweet_id: tweet.id)
          end
          has_many :comments, dependent: :destroy
        end
