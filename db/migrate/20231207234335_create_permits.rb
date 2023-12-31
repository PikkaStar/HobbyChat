class CreatePermits < ActiveRecord::Migration[6.1]
  def change
    create_table :permits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.boolean :rejected,null: false,default: false

      t.timestamps
    end
  end
end
