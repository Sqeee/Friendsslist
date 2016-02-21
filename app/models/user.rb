class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_attached_file :profile_picture, styles: { medium: "300x300>", thumb: "50x50#" }, default_url: "/images/:style/missing.jpeg"
  validates_attachment_content_type :profile_picture, content_type: %r{\Aimage\/.*\Z}
  
  has_many :posts
  has_many :friendships
  has_many :personal_infos
  has_many :comments
  has_many :messages
  has_many :likes
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  def to_s
    first_name + " " + last_name
  end
  
  def count_unread_messages
    Message.where(:read => false, :receiver => self.id).count
  end
  
  def count_friendship_waiting_for_approving
    Friendship.where(:approved => false, :user2_id => self.id).count
  end
  
  def is_friend_with_user_id?(user_id)
    Friendship.where("user1_id = :this_user AND user2_id = :user AND approved = :approved", { this_user: self.id, user: user_id, approved: true}).any?
  end
end
