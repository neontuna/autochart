class User < ActiveRecord::Base

  has_secure_password
  before_create :generate_token

  validates :email, presence: true, 
                  uniqueness: true

  def regenerate_auth_token
    self.auth_token = nil
    generate_token
    save!
  end


  def generate_token
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: self[:auth_token])
  end

end
