module ApplicationHelper
	def authenticity_token 
		"<input 
			type='hidden'
			name='authenticity_token'
			value='#{form_authenticity_token}'
		/>".html_safe
	end

	def edit_icon(edit_url)
		"<a href='#{edit_url}'>
			<svg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24'>
				<path d='M18 14.45v6.55h-16v-12h6.743l1.978-2h-10.721v16h20v-10.573l-2 2.023zm1.473-10.615l1.707 1.707-9.281 9.378-2.23.472.512-2.169 9.292-9.388zm-.008-2.835l-11.104 11.216-1.361 5.784 5.898-1.248 11.103-11.218-4.536-4.534z'/>
			</svg>
		</a>".html_safe 
	end

	def delete_icon(action_url, item)
		"<div>
			<form action='#{action_url}' method='post' id='delete_form_#{item.id}'>
				<input type='hidden' name='_method' value='delete'>
				#{authenticity_token}
			</form>
			<button type='submit' form='delete_form_#{item.id}'>
				<svg width='24' height='24' xmlns='http://www.w3.org/2000/svg' fill-rule='evenodd' clip-rule='evenodd'>
					<path d='M19 24h-14c-1.104 0-2-.896-2-2v-17h-1v-2h6v-1.5c0-.827.673-1.5 1.5-1.5h5c.825 0 1.5.671 1.5 1.5v1.5h6v2h-1v17c0 1.104-.896 2-2 2zm0-19h-14v16.5c0 .276.224.5.5.5h13c.276 0 .5-.224.5-.5v-16.5zm-9 4c0-.552-.448-1-1-1s-1 .448-1 1v9c0 .552.448 1 1 1s1-.448 1-1v-9zm6 0c0-.552-.448-1-1-1s-1 .448-1 1v9c0 .552.448 1 1 1s1-.448 1-1v-9zm-2-7h-4v1h4v-1z'/>
				</svg>
			</button>
		</div>".html_safe
	end
end
