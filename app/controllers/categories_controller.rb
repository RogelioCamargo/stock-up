class CategoriesController < ApplicationController
	def index 
		@categories = Category.all
		render :index
	end

	def show 
		@categories = Category.all 
		@category = Category.find(params[:id])
		render :show 
	end

	def edit 
		@category = Category.find(params[:id])
		render :edit
	end

	def create 
		@category = Category.new(category_params)
		if @category.save 
			redirect_to categories_url
		else
			flash[:errors] = @category.errors.full_messages
			redirect_to categories_url, status: :unprocessable_entity
		end
	end

	def update 
		@category = Category.find(params[:id])
		if @category.update(category_params)
			redirect_to categories_url
		else 
			flash.now[:errors] = @category.errors.full_messages
			render :edit,  status: :unprocessable_entity
		end
	end

	def destroy 
		category = Category.find(params[:id])
		category.destroy
		redirect_to categories_url 
	end

	private 

	def category_params
		params.require(:category).permit(:name)
	end	
end