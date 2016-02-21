class Friendship < ActiveRecord::Base
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  validates_inclusion_of :approved, in: [true, false]
  validates_presence_of :user1_id
  validates_presence_of :user2_id
  validate :check_user1_user2
  
  def check_user1_user2
    errors.add(:user2_id, "can't be the same as User1") if user1_id == user2_id
  end
end
