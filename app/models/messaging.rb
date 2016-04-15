class Messaging < ActiveRecord::Base

    attr_accessor :image_cache
  has_attached_file :image, styles: { medium: "300x300>", large: "600x600>" }, default_url: "/images/:style/missing.png"

  def cache_images
    if image.staged?
      if invalid?
        FileUtils.cp(image.queued_for_write[:original].path, image.path(:original))
        @image_cache = encrypt(image.path(:original))
      end
    else
      if @image_cache.present?
        File.open(decrypt(@image_cache)) {|f| assign_attributes(image: f)}
      end
    end
  end

  private

  def decrypt(data)
    return '' unless data.present?
    cipher = build_cipher(:decrypt, 'mypassword')
    cipher.update(Base64.urlsafe_decode64(data).unpack('m')[0]) + cipher.final
  end

  def encrypt(data)
    return '' unless data.present?
    cipher = build_cipher(:encrypt, 'mypassword')
    Base64.urlsafe_encode64([cipher.update(data) + cipher.final].pack('m'))
  end

  def build_cipher(type, password)
    cipher = OpenSSL::Cipher::Cipher.new('DES-EDE3-CBC').send(type)
    cipher.pkcs5_keyivgen(password)
    cipher
  end


end
