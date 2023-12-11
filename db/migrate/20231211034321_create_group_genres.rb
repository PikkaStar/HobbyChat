class CreateGroupGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :group_genres do |t|
      t.references :group, null: false
      t.references :genre, null: false

      t.timestamps
    end
  end
end
