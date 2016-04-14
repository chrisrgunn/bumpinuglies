class AddAttachmentImageToMessagings < ActiveRecord::Migration
  def self.up
    change_table :messagings do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :messagings, :image
  end
end
