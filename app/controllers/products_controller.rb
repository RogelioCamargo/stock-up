require 'httparty'
require 'dotenv'

class ProductsController < ApplicationController
	include HTTParty

	def index 
		@products = Product.all.includes(:category)
		@categories = Category.all 
		render :index
	end

	def create 
		@product = Product.new(product_params)
		if @product.save 
			if params[:from_category]
				redirect_to category_url(@product.category_id)
			else
				redirect_to products_url
			end
		else
			if params[:from_category]
				flash[:errors] = @product.errors.full_messages
				redirect_to category_url(@product.category_id)
			else
				flash.now[:errors] = @product.errors.full_messages
				render :index
			end
		end
	end

	def dashboard 
		@products = Product.where(status: 1).includes(:category)
		render :dashboard
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

	def request_products 
		product_names = Product.where(status: 1).map(&:name)
		HTTParty.post(ENV["SLACK_WEBHOOK_URL"], 
			body: { text: product_names.join("\n") }.to_json, 
			header: { 'Content-Type': 'application/json' })
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
			if params[:from_category]
				redirect_to category_url(@product.category_id)
			else
				redirect_to products_url
			end
		else
			if params[:from_category]
				flash[:errors] = @product.errors.full_messages
				redirect_to category_url(@product.category_id)
			else
				flash.now[:errors] = @product.errors.full_messages
				render :index
			end
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