class UsersController < ApplicationController
	before_action :require_user!, only: %i(show)
	def new 
		@user = User.new 
		render :new
	end

	def create 
		@user = User.new(user_params)
		if @user.save 
			login_user!(@user)
			redirect_to user_url(@user)
		else 
			flash.now[:errors] = @user.errors.full_messages 
			render :new, status: :unprocessable_entity
		end
	end

	def show 
		@user = User.find(params[:id])
		render :show 
	end

	private 

	def user_params 
		params.require(:user).permit(:username, :password, :email)
	end
end