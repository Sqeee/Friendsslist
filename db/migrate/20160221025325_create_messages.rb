class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
      t.boolean :read

      t.timestamps null: false
    end
    
    add_reference :messages, :sender, references: :user, index: true, foreign_key: true
    add_reference :messages, :receiver, references: :user, index: true, foreign_key: true
  end
end
