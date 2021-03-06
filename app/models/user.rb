class User < ApplicationRecord
	validates :username, :email, :session_token, presence: true 
	validates :password_digest, presence: { message: "Password can't be blank" }
	validates :username, :session_token, uniqueness: true 
	validates :password, length: { minimum: 4, allow_nil: true }
	after_initialize  :ensure_session_token 

	attr_reader :password

	has_many :products, dependent: :destroy

	def self.generate_session_token 
		session_token = SecureRandom::urlsafe_base64(16)
		while User.exists?(session_token: session_token) do 
		 session_token = SecureRandom::urlsafe_base64(16)
		end
		session_token
	end

	def self.find_by_credentials(username, password) 
		user = User.find_by(username: username)
		return nil if user.nil? 
		user.is_password?(password) ? user : nil
	end

	def reset_session_token! 
		self.session_token = User.generate_session_token
		self.save!
		self.session_token 
	end

	def password=(password)
		@password = password 
		self.password_digest = BCrypt::Password.create(password)
	end

	def is_password?(password)
		BCrypt::Password.new(self.password_digest).is_password?(password)
	end

	private 

	def ensure_session_token 
		self.session_token ||= User.generate_session_token
	end
end
