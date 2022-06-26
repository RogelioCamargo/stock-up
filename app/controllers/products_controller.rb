class ProductsController < ApplicationController
	def index 
		@products = Product.all.includes(:category)
		@categories = Category.all 
		render :index
	end

	def create 
		@product = Product.new(product_params)
		if @product.save 
			redirect_to category_url(@product.category_id)
		else
			flash[:errors] = @product.errors.full_messages
			redirect_to products_url, status: :unprocessable_entity
		end
	end

	def order_list 
		@products = Product.where(status: 1).includes(:category)
		render :order_list
	end

	def order_more 
		product = Product.find(params[:id])
		product.update(status: 1)
		redirect_to category_url(product.category_id)
	end

	def ordered_more 
		product = Product.find(params[:id])
		product.update(status: 0)
		redirect_to category_url(product.category_id)
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
			redirect_to category_url(@product.category_id)
		else
			flash.now[:errors] = @product.errors.full_messages
			render :edit, status: :unprocessable_entity
		end
	end

	def destroy
		product = Product.find(params[:id])
		product.destroy
		redirect_to category_url(product.category_id) 
	end 

	private 

	def product_params 
		params.require(:product).permit(:name, :quantity, :image_url, :shop_url, :category_id)
	end
end