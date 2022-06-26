module ProductsHelper
	def products_table_head
		"<thead>
			<tr>
				<th>Name</th>
				<th>Quantity</th>
				<th>Category</th>
				<th>Actions</th>
			</tr>
		</thead>".html_safe
	end

	def products_table_row(product)
		"<tr>
			<td>#{product.name}</td>
			<td>
				#{product_quantity_form product}
			</td>
			<td>#{product.category.name}</td>
			<td>
				#{edit_icon edit_product_url(product)}
				#{delete_icon product_url(product), product}
				#{product.status == 0 ?
					product_order_more_form(product) :
					product_ordered_more_form(product)}
			</td>
		</tr>".html_safe
	end

	def product_quantity_form(product)
		"<form action='#{product_url(product)}' method='post'>
			<input type='hidden' name='_method' value='patch'>
			#{authenticity_token}
			<input type='number' name='product[quantity]' value='#{product.quantity}'>
			<input type='submit' value='Update'>
		</form>".html_safe
	end	

	def product_order_more_form(product)
		"<form action='#{order_more_product_url(product)}' method='post'>
			#{authenticity_token}
			<input type='submit' value='Order More'>
		</form>".html_safe
	end

	def product_ordered_more_form(product) 
		"<form action='#{ordered_more_product_url(product)}' method='post'>
			#{authenticity_token}
			<input type='submit' value='Items Arrived'>
		</form>".html_safe
	end
end