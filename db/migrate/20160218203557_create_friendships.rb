class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.boolean :approved

      t.timestamps null: false
    end
    
    add_reference :friendships, :user1, references: :user, index: true, foreign_key: true
    add_reference :friendships, :user2, references: :user, index: true, foreign_key: true
  end
end
