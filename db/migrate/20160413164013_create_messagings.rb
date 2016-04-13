class CreateMessagings < ActiveRecord::Migration
  def change
    create_table :messagings do |t|
      t.datetime :date
      t.string :receiver
      t.string :sender
      t.string :message

      t.timestamps null: false
    end
  end
end
