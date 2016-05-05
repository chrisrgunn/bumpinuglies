class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.attachment :image
      t.datetime :date
      t.string :location
      t.text :details
      t.timestamps null: false
    end
  end
end
