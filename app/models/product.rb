class Product < ApplicationRecord
	validates :name, :status, presence: true 
	after_initialize :ensure_status 

	belongs_to :category
	belongs_to :user, optional: true

	private 

	def ensure_status 
		self.status ||= 0
	end
end
