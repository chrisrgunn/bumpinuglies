class AddAvatarsToUsers < ActiveRecord::Migration
  def up
       add_attachment :users, :avatar
    end
  end

  def down
    remove_attachment :users, :avatar
  end
end