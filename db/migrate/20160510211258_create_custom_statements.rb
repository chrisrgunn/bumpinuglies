class CreateCustomStatements < ActiveRecord::Migration
  def change
    create_table :custom_statements do |t|
      t.string :statement
      t.integer :importance
      t.integer :degree_of_truth
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
