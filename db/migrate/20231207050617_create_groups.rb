class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :introduction, null: false, default: "よろしくお願いします。"
      t.string :image_id
      t.integer :owner_id, null: false
      t.references :user

      t.timestamps
    end
  end
end
