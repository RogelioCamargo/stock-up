class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception 
	before_action :set_cache_headers

	helper_method :current_user, :logged_in? 

	def current_user 
		return nil unless session[:session_token]
		@current_user = User.find_by(session_token: session[:session_token])
	end

	def logged_in? 
		!current_user.nil? 
	end

	def login_user!(user)
		session[:session_token] = user.reset_session_token!
	end

	def logout_user!
		current_user.reset_session_token! 
		session[:session_token] = nil 
	end 

	def require_user! 
		redirect_to new_session_url if current_user.nil? 
	end


  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end
end
