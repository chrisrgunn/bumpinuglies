class AddAttachmentDiagramToAnswers < ActiveRecord::Migration
  def self.up
    change_table :answers do |t|
      t.attachment :diagram
    end
  end

  def self.down
    remove_attachment :answers, :diagram
  end
end
