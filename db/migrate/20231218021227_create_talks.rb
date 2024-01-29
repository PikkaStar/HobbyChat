class CreateTalks < ActiveRecord::Migration[6.1]
  def change
    create_table :talks do |t|
      t.references :user
      t.references :area
      t.string :message, null: false

      t.timestamps
    end
  end
end
