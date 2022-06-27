Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
	resources :users, only: %i(new create show)
	resource :session, only: %i(new create destroy)
	resources :categories, except: %i(new)
	resources :products, expect: %i(new) do 
		collection do 
			get :order_list
			post :request_products
		end
		member do 
			post :order_more
			post :ordered_more
		end
	end
end
