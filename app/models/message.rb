class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  validates_presence_of :text
  validates_inclusion_of :read, in: [true, false]
  validates_presence_of :sender_id
  validates_presence_of :receiver_id
  validate :check_sender_receiver
  
  def check_sender_receiver
    errors.add(:sender_id, "can't be the same as Receiver") if sender_id == receiver_id
  end
  
  def color_class(user)
    if self.sender == user
      "info"
    elsif !self.read
      "warning"
    else
      "active"
    end
  end
end
