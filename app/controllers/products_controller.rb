require 'httparty'
require 'dotenv'

class ProductsController < ApplicationController
	before_action :require_user!

	include HTTParty

	def index 
		@products = Product.all.includes(:category)
		@categories = Category.all
		render :index
	end

	def create 
		@product = Product.new(product_params)
		if @product.save 
			case params[:location].to_i
			when 1
				redirect_to category_url(@product.category_id)
			when 2 
				redirect_to products_url 
			else 
				fail 
			end
		else
			case params[:location].to_i
			when 1
				flash[:errors] = @product.errors.full_messages
				redirect_to category_url(@product.category_id)
			when 2
				flash.now[:errors] = @product.errors.full_messages
				render :index
			else
				fail
			end
		end
	end

	def dashboard 
		@requested_products = Product.where(status: 1).includes(:category)
		@ordered_products = Product.where(status: 2).includes(:category)
		render :dashboard
	end

	def order 
		product = Product.find(params[:id])
		if product.update(status: 1)
			case params[:location].to_i
			when 0 
				redirect_to dashboard_products_url
			when 1
				redirect_to category_url(product.category_id)
			when 2 
				redirect_to products_url 
			else 
				fail 
			end
		else 
			fail 
		end
	end

	def ordered 
		product = Product.find(params[:id])
		if product.update(status: 2)
			case params[:location].to_i
			when 0 
				redirect_to dashboard_products_url
			when 1
				redirect_to category_url(product.category_id)
			when 2 
				redirect_to products_url 
			else 
				fail 
			end
		else
			fail 
		end
	end

	def received 
		product = Product.find(params[:id])
		if product.update(status: 0)
			case params[:location].to_i
			when 0 
				redirect_to dashboard_products_url
			when 1
				redirect_to category_url(product.category_id)
			when 2 
				redirect_to products_url 
			else 
				fail 
			end
		else  
			fail 
		end
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
			case params[:location].to_i
			when 0 
				redirect_to dashboard_products_url
			when 1
				redirect_to category_url(@product.category_id)
			when 2 
				redirect_to products_url 
			else 
				fail 
			end
		else
			case params[:location].to_i
			when 1
				flash[:errors] = @product.errors.full_messages
				redirect_to category_url(@product.category_id)
			when 2
				flash.now[:errors] = @product.errors.full_messages
				render :index
			else
				fail
			end
		end
	end

	def order_all_requested
		Product.where(status: 1).update_all(status: 2)
		redirect_to dashboard_products_url
	end

	def receive_all_ordered
		Product.where(status: 2).update_all(status: 0)
		redirect_to dashboard_products_url
	end

	def destroy
		product = Product.find(params[:id])
		product.destroy
		redirect_to category_url(product.category_id) 
	end 

	private 

	def product_params 
		params.require(:product).permit(:name, :quantity, :shop_url, :category_id, :reorder_amount, :unit_of_measure, :delivery_window)
	end
end