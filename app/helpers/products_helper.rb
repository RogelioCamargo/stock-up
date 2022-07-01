module ProductsHelper
	def products_table_head
		"<thead>
			<tr>
				<th class='w-25-rem'>Name</th>
				<th class='w-10-rem'>Quantity</th>
				<th >Category</th>
				<th>Actions</th>
				<th class='w-10-rem'>Reorder Amount</th>
				<th>Modified</th>
			</tr>
		</thead>".html_safe
	end

	def products_table_row(product, location)
		"<tr>
			<td class='w-25-rem'>#{product.name}</td>
			<td class='w-10-rem'>
			#{product_quantity_form(product, location)}
			</td>
			<td class='text-nowrap'>#{product.category.name}</td>
			<td class='d-flex'>
				<div>
					#{product.status == 0 ?
					request_button(product, location) :
					(product.status == 1 ? 
						ordered_button(product, location) :
						received_button(product, location))}
				</div>
				<div class='ms-1'>
					<a class='btn btn-outline-primary btn-sm #{product.shop_url.empty? && 'disabled'}' href='#{product.shop_url}'>
						<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-link' viewBox='0 0 16 16'>
							<path d='M6.354 5.5H4a3 3 0 0 0 0 6h3a3 3 0 0 0 2.83-4H9c-.086 0-.17.01-.25.031A2 2 0 0 1 7 10.5H4a2 2 0 1 1 0-4h1.535c.218-.376.495-.714.82-1z'/>
							<path d='M9 5.5a3 3 0 0 0-2.83 4h1.098A2 2 0 0 1 9 6.5h3a2 2 0 1 1 0 4h-1.535a4.02 4.02 0 0 1-.82 1H12a3 3 0 1 0 0-6H9z'/>
						</svg>
					</a>
				</div>
			</td>
			<td class='w-10-rem'>#{product.reorder_amount}</td>
			<td class='text-nowrap'>
				#{product.updated_at.strftime("%m/%d/%Y")}
				#{product.updated_at.in_time_zone("Pacific Time (US & Canada)").strftime("%I:%M%p")}
			</td>
		</tr>".html_safe
	end

	def product_quantity_form(product, location)
		"<form action='#{product_url(product)}#{"?location=#{location}"}' method='post'>
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

	def request_button_mobile(product, location)
		"<form action='#{order_product_url(product)}#{"?location=#{location}"}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary ms-1 btn-sm' type='submit'>
				#{request_icon}
			</button>
		</form>".html_safe
	end

	def request_button(product, location)
		"<form action='#{order_product_url(product)}#{"?location=#{location}"}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary btn-sm text-nowrap w-7-rem' type='submit'>
				#{request_icon}
				<span class='ms-1'>Request</span>
			</button>
		</form>".html_safe
	end

	def ordered_button_mobile(product, location) 
		"<form action='#{ordered_product_url(product)}#{"?location=#{location}"}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary ms-1 btn-sm' type='submit'>
				#{ordered_icon}
			</button>
		</form>".html_safe
	end

	def ordered_button(product, location) 
		"<form action='#{ordered_product_url(product)}#{"?location=#{location}"}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary btn-sm text-nowrap w-7-rem' type='submit'>
				#{ordered_icon}
				<span class='ms-1'>Order</span>
			</button>
		</form>".html_safe
	end

	def received_button_mobile(product, location) 
		"<form action='#{received_product_url(product)}#{"?location=#{location}"}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary ms-1 btn-sm' type='submit'>
				#{received_icon}
			</button>
		</form>".html_safe
	end

	def received_button(product, location) 
		"<form action='#{received_product_url(product)}#{"?location=#{location}"}' method='post'>
			#{authenticity_token}
			<button class='btn btn-primary btn-sm text-nowrap w-7-rem' type='submit'>
				#{received_icon}
				<span class='ms-1'>Received</span>
			</button>
		</form>".html_safe
	end

	def request_icon
		"<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-cart-plus' viewBox='0 0 16 16'>
			<path d='M9 5.5a.5.5 0 0 0-1 0V7H6.5a.5.5 0 0 0 0 1H8v1.5a.5.5 0 0 0 1 0V8h1.5a.5.5 0 0 0 0-1H9V5.5z'/>
			<path d='M.5 1a.5.5 0 0 0 0 1h1.11l.401 1.607 1.498 7.985A.5.5 0 0 0 4 12h1a2 2 0 1 0 0 4 2 2 0 0 0 0-4h7a2 2 0 1 0 0 4 2 2 0 0 0 0-4h1a.5.5 0 0 0 .491-.408l1.5-8A.5.5 0 0 0 14.5 3H2.89l-.405-1.621A.5.5 0 0 0 2 1H.5zm3.915 10L3.102 4h10.796l-1.313 7h-8.17zM6 14a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm7 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z'/>
		</svg>".html_safe
	end

	def ordered_icon 
		"<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-truck' viewBox='0 0 16 16'>
				<path d='M0 3.5A1.5 1.5 0 0 1 1.5 2h9A1.5 1.5 0 0 1 12 3.5V5h1.02a1.5 1.5 0 0 1 1.17.563l1.481 1.85a1.5 1.5 0 0 1 .329.938V10.5a1.5 1.5 0 0 1-1.5 1.5H14a2 2 0 1 1-4 0H5a2 2 0 1 1-3.998-.085A1.5 1.5 0 0 1 0 10.5v-7zm1.294 7.456A1.999 1.999 0 0 1 4.732 11h5.536a2.01 2.01 0 0 1 .732-.732V3.5a.5.5 0 0 0-.5-.5h-9a.5.5 0 0 0-.5.5v7a.5.5 0 0 0 .294.456zM12 10a2 2 0 0 1 1.732 1h.768a.5.5 0 0 0 .5-.5V8.35a.5.5 0 0 0-.11-.312l-1.48-1.85A.5.5 0 0 0 13.02 6H12v4zm-9 1a1 1 0 1 0 0 2 1 1 0 0 0 0-2zm9 0a1 1 0 1 0 0 2 1 1 0 0 0 0-2z'/>
			</svg>".html_safe
	end

	def received_icon 
		"<svg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='currentColor' class='bi bi-hand-thumbs-up' viewBox='0 0 16 16'>
			<path d='M8.864.046C7.908-.193 7.02.53 6.956 1.466c-.072 1.051-.23 2.016-.428 2.59-.125.36-.479 1.013-1.04 1.639-.557.623-1.282 1.178-2.131 1.41C2.685 7.288 2 7.87 2 8.72v4.001c0 .845.682 1.464 1.448 1.545 1.07.114 1.564.415 2.068.723l.048.03c.272.165.578.348.97.484.397.136.861.217 1.466.217h3.5c.937 0 1.599-.477 1.934-1.064a1.86 1.86 0 0 0 .254-.912c0-.152-.023-.312-.077-.464.201-.263.38-.578.488-.901.11-.33.172-.762.004-1.149.069-.13.12-.269.159-.403.077-.27.113-.568.113-.857 0-.288-.036-.585-.113-.856a2.144 2.144 0 0 0-.138-.362 1.9 1.9 0 0 0 .234-1.734c-.206-.592-.682-1.1-1.2-1.272-.847-.282-1.803-.276-2.516-.211a9.84 9.84 0 0 0-.443.05 9.365 9.365 0 0 0-.062-4.509A1.38 1.38 0 0 0 9.125.111L8.864.046zM11.5 14.721H8c-.51 0-.863-.069-1.14-.164-.281-.097-.506-.228-.776-.393l-.04-.024c-.555-.339-1.198-.731-2.49-.868-.333-.036-.554-.29-.554-.55V8.72c0-.254.226-.543.62-.65 1.095-.3 1.977-.996 2.614-1.708.635-.71 1.064-1.475 1.238-1.978.243-.7.407-1.768.482-2.85.025-.362.36-.594.667-.518l.262.066c.16.04.258.143.288.255a8.34 8.34 0 0 1-.145 4.725.5.5 0 0 0 .595.644l.003-.001.014-.003.058-.014a8.908 8.908 0 0 1 1.036-.157c.663-.06 1.457-.054 2.11.164.175.058.45.3.57.65.107.308.087.67-.266 1.022l-.353.353.353.354c.043.043.105.141.154.315.048.167.075.37.075.581 0 .212-.027.414-.075.582-.05.174-.111.272-.154.315l-.353.353.353.354c.047.047.109.177.005.488a2.224 2.224 0 0 1-.505.805l-.353.353.353.354c.006.005.041.05.041.17a.866.866 0 0 1-.121.416c-.165.288-.503.56-1.066.56z'/>
		</svg>".html_safe
	end
end

