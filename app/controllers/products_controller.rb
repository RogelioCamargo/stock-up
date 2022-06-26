class ProductsController < ApplicationController
	def index 
		@products = Product.all
		@categories = Category.all 
		render :index
	end

	def create 
		@product = Product.new(product_params)
		if @product.save 
			redirect_to products_url
		else
			flash[:errors] = @product.errors.full_messages
			redirect_to products_url, status: :unprocessable_entity
		end
	end

	def edit 
		@product = Product.find(params[:id])
		render :edit
	end

	def show 
		@product = Product.find(params[:id])
		render :show
	end

	def update 
		@product = Product.find(params[:id])
		if @product.update(product_params)
			redirect_to products_url
		else
			flash.now[:errors] = @product.errors.full_messages
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		product = Product.find(params[:id])
		product.destroy
		redirect_to products_url 
	end 

	private 

	def product_params 
		params.require(:product).permit(:name, :quantity, :image_url, :shop_url, :category_id)
	end
end