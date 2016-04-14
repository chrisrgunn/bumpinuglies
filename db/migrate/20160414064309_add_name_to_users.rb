class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :date_of_birth, :datetime
    add_column :users, :is_female, :boolean, default: false
    add_column :users, :age, :integer
    add_column :users, :dating, :boolean
    add_column :users, :serious_relationship, :string
    add_column :users, :friends, :string
  end
end
