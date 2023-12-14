class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|

      # ポリモーフィック関連付け
      t.references :subject, polymorphic: true
      t.references :user, foreign_key: true
      t.integer :action_type, null: false
      t.boolean :checked, default: false, null: false
      t.integer :visitor_id
      t.integer :visited_id

      t.timestamps
    end
  end
end
