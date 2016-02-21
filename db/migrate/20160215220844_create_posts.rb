class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :text

      t.timestamps null: false
    end

    add_reference :posts, :author, references: :user, index: true, foreign_key: true
    add_reference :posts, :owner, references: :user, index: true, foreign_key: true
  end
end
