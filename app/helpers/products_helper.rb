module ProductsHelper
	def products_table_head
		"<thead>
			<tr>
				<th class='col-5' scope='col'>Name</th>
				<th class='col-2' scope='col'>Quantity</th>
				<th class='col' scope='col'>Category</th>
				<th class='col-2' scope='col'>Actions</th>
			</tr>
		</thead>".html_safe
	end

	def products_table_row(product)
		"<tr class='' scope='row'>
			<td>#{product.name}</td>
			<td>
				#{product_quantity_form product}
			</td>
			<td class=''>#{product.category.name}</td>
			<td class=''>
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
			<div class='d-flex'>
				<input type='number' class='form-control form-control-sm me-1' name='product[quantity]' value='#{product.quantity}'>
				<button class='btn btn-primary btn-sm' type='submit'>
					<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-check-circle-fill' viewBox='0 0 16 16'>
						<path d='M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z'/>
					</svg>
				</button>
			</div>
		</form>".html_safe
	end	

	def product_order_more_form(product)
		"<form action='#{order_more_product_url(product)}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary btn-sm btn-w-md' type='submit'>
				Request More
			</button>
		</form>".html_safe
	end

	def product_ordered_more_form(product) 
		"<form action='#{ordered_more_product_url(product)}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary btn-sm btn-w-md' type='submit'>
				Order Placed
			</button>
		</form>".html_safe
	end
end

