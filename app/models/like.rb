class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true
  belongs_to :user
  
  def self.get_class(likeable, user)
    unless likeable.likes.where(:user_id => user.id).any?
      "btn btn-default"
    else
      "btn btn-primary"
    end
  end
end
