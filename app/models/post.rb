class Post < ActiveRecord::Base
  belongs_to :author, class_name: 'User'
  belongs_to :owner, class_name: 'User'
  validates_presence_of :text
  validates_presence_of :author_id
  validates_presence_of :owner_id
  
  has_many :comments, dependent: :delete_all
  has_many :likes, as: :likeable, dependent: :delete_all
end
