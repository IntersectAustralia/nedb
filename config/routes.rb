Nedb::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "user_registers"} do
    get "/users/edit_password", :to => "user_registers#edit_password" #allow users to edit their own password
    put "/users/update_password", :to => "user_registers#update_password" #allow users to edit their own password
    get "/users/feedback", :to => "user_registers#feedback" #allow users to send feedback
    post "/users/feedback", :to => "user_registers#send_feedback" #allow users to send feedback
  end

  resources :users, :only => [:show] do
    collection do
      get :access_requests
      get :index
    end
    
    member do
      put :reject
      put :reject_as_spam
      put :deactivate
      put :activate
      get :edit_profile
      put :update_profile
      get :edit_approval
      put :approve
    end
  end

  resources :herbaria, :except => [:show, :destroy] do
    collection do
      get :autocomplete_herbarium_name
      get :search
    end
  end

  resources :people do
    collection do
      get :search
      get :search_results
    end
  end

  resources :species do
    resources :varieties, :except => [:index, :show]
    resources :forms, :except => [:index, :show]
    resources :subspecies, :except => [:index, :show]

    collection do
      get :autocomplete_plant_name
    end
  end

  resources :specimens, :except => [:index, :destroy] do
    resources :determinations, :except => [:index, :destroy] do
      resources :confirmations, :except => [:index, :show, :destroy]
    end
    resources :items, :only => [:destroy]
    resources :specimen_images do
      member do
        get "/style/:style", :to => "specimen_images#display_image", :as => :display_image
        get :download
      end
    end

    member do
      get :edit_replicates
      get :labels
      get :download_zip
      put :update_replicates
      post :add_item
      post :request_deaccession
      post :approve_deaccession
      post :unflag_deaccession
      post :mark_as_reviewed
    end

    collection do
      get :search
      get :search_results
      get :search_results_print_labels
      get :advanced_search
      get :advanced_search_form
      get :latest
      get :needing_review
    end
  end

  get "pages/home"
  get "pages/admin"
  get "javascripts/dynamic_states"
  get "javascripts/determinations"
  get "javascripts/specimens"

  match '*a', :to => 'application#routing_error'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "pages#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
