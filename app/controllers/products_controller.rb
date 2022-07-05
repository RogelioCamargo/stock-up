require 'httparty'
require 'dotenv'

class ProductsController < ApplicationController
	before_action :require_user!, :set_cache_headers
	include HTTParty

	def index 
		@product = Product.new 
		@products = Product.all.includes(:category)
		@categories = Category.all
		render :index
	end

	def create 
		@product = Product.new(product_params)
		if @product.save 
			case params[:location].to_i
			when 1
				redirect_to category_path(product.category_id, anchor: @product.id)
			when 2 
				redirect_to products_path(anchor: @product.id)  
			else 
				fail 
			end
		else
			case params[:location].to_i
			when 1
				flash[:errors] = @product.errors.full_messages
				redirect_to category_url(@product.category_id)
			when 2
				flash[:errors] = @product.errors.full_messages
				redirect_to products_url
			else
				fail
			end
		end
	end

	def dashboard 
		@products = Product.all.reload
		render :dashboard
	end

	def order 
		product = Product.find(params[:id])
		if product.update(status: 1)
			case params[:location].to_i
			when 0 
				redirect_to dashboard_products_path
			when 1
				redirect_to category_path(product.category_id, anchor: product.id)
			when 2 
				redirect_to products_path(anchor: product.id)
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
				redirect_to dashboard_products_path
			when 1
				redirect_to category_path(product.category_id, anchor: product.id)
			when 2 
				redirect_to products_path(anchor: product.id) 
			else 
				fail 
			end
		else
			fail 
		end
	end

	def received 
		product = Product.find(params[:id])
		if product.update(status: 0, quantity: nil)
			case params[:location].to_i
			when 0
				redirect_to dashboard_products_path
			when 1
				redirect_to category_path(product.category_id, anchor: product.id)
			when 2 
				redirect_to products_path(anchor: product.id) 
			else 
				fail 
			end
		else  
			fail 
		end
	end

	def request_products 
		products = Product.where(status: 1)
		sections = []
		products.each do |product|
			fields = []
			if product.shop_url.empty? 
				fields << { type: "mrkdwn", text: "*#{product.name}*" }
			else 
				fields << { type: "mrkdwn", text: "<#{product.shop_url}|#{product.name}>"}
			end

			second_column_text = "" 
			second_column_text += "*Quantity*: #{product.quantity}\n" unless product.quantity.nil? 
			second_column_text += "*Reorder*: #{product.reorder_amount}" unless product.reorder_amount.nil? 

			unless second_column_text.empty? 
				fields << { type: "mrkdwn", text: second_column_text }
			end

			sections << { type: "section", fields: fields }
			sections << { type: "divider" }
		end

		HTTParty.post(ENV["SLACK_WEBHOOK_URL"], 
			body: { 
				"blocks": [
					{
						"type": "header",
						"text": {
							type: "plain_text",
							text: "New Request\n",
							emoji: true 
						}
					}, 
					{
						type: "divider"
					},
					*sections,
					{
						type: "section",
						text: {
							type: "mrkdwn",
							text: "<https://stockup-switch.herokuapp.com|Open App>"
						}
					}
				]
			 }.to_json, 
			header: { 'Content-Type': 'application/json' })
	end

	def edit 
		@product = Product.find(params[:id])
		@categories = Category.all 
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
				redirect_to dashboard_products_path
			when 1
				redirect_to category_path(@product.category_id, anchor: @product.id)
			when 2 
				redirect_to products_path(anchor: @product.id)  
			when 3 
				redirect_to product_url(@product)
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
			when 3
				flash[:errors] = @product.errors.full_messages
				redirect_to edit_product_url(@product)
			else
				fail
			end
		end
	end

	def order_all_requested
		Product.where(status: 1).update_all(status: 2)
		redirect_to dashboard_products_path
	end

	def receive_all_ordered
		Product.where(status: 2).update_all(status: 0)
		redirect_to dashboard_products_path
	end

	def destroy
		product = Product.find(params[:id])
		product.destroy
		redirect_to category_url(product.category_id) 
	end 

	private 

	def product_params 
		params.require(:product).permit(:name, :quantity, :category_id,:unit_of_measure, :reorder_limit, :reorder_amount, :shop_url, :delivery_window)
	end
end