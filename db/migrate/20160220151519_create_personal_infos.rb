class CreatePersonalInfos < ActiveRecord::Migration
  def change
    create_table :personal_infos do |t|
      t.string :title
      t.text :text
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
