class EncryptStringHelper 
  def self.encrypt_string(string, salt = nil)
    encrypted_salt = salt.present? ? salt : BCrypt::Engine.generate_salt  
    encrypted_hash = BCrypt::Engine.hash_secret(string, encrypted_salt)

    return :salt => encrypted_salt, :hash => encrypted_hash
  end
end