class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  validates_presence_of :text
  validates_presence_of :user_id
  validates_presence_of :post_id
  
  has_many :likes, as: :likeable, dependent: :delete_all
end
