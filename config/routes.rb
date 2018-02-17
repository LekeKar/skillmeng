Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => {:omniauth_callbacks => "omniauth_callbacks", :registrations => 'registrations'}
  
  get '/users/:id', :to => 'users#show', :as => :user
  get '/users/:id/barter', :to => 'users#barter', :as => :barter
  post 'course_requests/:course_request_id/barter_response', :to => 'users#barter_response', :as => :barter_response
  get '/users/:id/news', :to => 'users#news', :as => :news
  get '/users/:id/saved_courses', :to => 'users#saved_courses', :as => :saved_courses
  get '/:organizer_id/course_manager/:course_id', :to => 'courses#course_manager', :as => :course_manager
  get '/:course_id/tutor/:id', :to => 'tutors#add_remove_tutor', :as => :add_remove_tutor
  get 'toggle_broadcast/:favorite_course_id', :to => 'courses#toggle_broadcast', :as => :toggle_broadcast
  get 'toggle_subscription/:favorite_course_id', :to => 'courses#toggle_subscription', :as => :toggle_subscription
  post '/messages/send_message', :to => "messages#send_message", :as => "send_message"
  get '/:course_id/annoucement/:id', :to => "announcements#email_broadcast", :as => "email_broadcast"
  post '/store_location', :to => "welcome#store_location", :as => "store_location"

  resources :organizers, except: [:index] do 
    resources :organizer_orders
    resources :tutors, except: [:show, :index]
    get 'purchases'
  end 
  
  resources :announcements, except: [:show, :index]
  get '/course/:id/announcements', :to => 'announcements#index', :as => :course_announcements
  
  resources :conversations do
    get 'mark_as_read'
    get 'move_to_inbox'
    get 'delete_from_trash'
  	resources :messages
  end 
  
  resources :courses do
    resources :reviews, except: [:show, :index]
    resources :gallery_pics, except: [:show, :index] 
  	resources :abouts, except: [:show, :index] 
  	resources :course_payments, except: [:show, :index]
    resources :course_requests, except: [:show, :index] do
      get 'toggle_read'
    end 
  	resources :contacts, except: [:show, :index] 
  	resources :course_notifications, except: [:show, :index] 
  	resources :course_days, except: [:show, :index]
    resources :reports, except: [:show, :index]

      get 'rating'
      get 'make_primary'
    	get 'requests'
      get 'payment'
    	get 'course_wizard'
    	get 'contact_info'
    	get 'gallery'
      get 'toggle_activate', :on => :member
      get 'toggle_sold_out', :on => :member
    	put :favorite, on: :member
		collection do
			get 'search'
			get :autocomplete
 		end
 	end
	
	get 'tags/:tag', to: 'courses#index', as: :tag
	get 'welcome/about'
	root 'welcome#home'

end
