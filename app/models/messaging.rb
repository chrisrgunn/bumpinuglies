class Messaging < ActiveRecord::Base
  has_attached_file :image, styles: { large: "600x600>", medium: "300x300>", thumb: "150x150#"}
   validates_presence_of :image
   validates_attachment :image, :presence => true,
   :content_type => { :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
