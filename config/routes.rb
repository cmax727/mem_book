AroundYoga::Application.routes.draw do



  ## authorization
  devise_for :users,
    path: "",
    controllers: {
      sessions:           "users/sessions",
      passwords:          "users/passwords",
      confirmations:      "users/confirmations",
      omniauth_callbacks: "users/o_auth_callbacks",
      unlocks:            "users/unlocks",
      registrations:      "users/registrations"
    },
=begin
    skip: [
      :registrations
    ],
=end

    path_names: {
      sign_in:      'login',
      sign_out:     'logout',
      confirmation: 'verification',
    }


  post 'register',     to: "home#register", as: :register, format: false
  post 'create_user',  to: "home#create_user", as: :create_user, format: false

  match "/cities/autocomplete/:first_char" =>         "cities#autocomplete"
  match "/regions/fetch_regions/:country" =>          "regions#fetch_regions"
  match "/cities/fetch_cities/:country/:region" =>    "cities#fetch_cities"
  match "/interests/create/:interest" =>              "interests#create", :as => "creating"
  match "/interests/autocomplete/:first_char" =>      "interests#autocomplete"
  match "/events/autocomplete/:first_char" =>      "events#autocomplete"
  match "/groups/autocomplete/:first_char" =>      "groups#autocomplete"
  # match "/places/change_regions/:country" => "places#change_regions"

=begin  (current)
  ## resources
  resources :cities, format: false, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
    get   :autocomplete, on: :collection, format: false
  end
  

  resource  :strange,     format: false, path: :agree, only: [:edit, :update]
  resources :groups,      format: false
  resources :events,      format: false
  resources :discoveries, format: false
=end
  ## places
  resources :countries,   format: false, only: :show do
    resources :regions,   format: false, only: :show do
      resources :cities,  format: false, only: :show
    end
    get 'show_all_on_place',        on: :collection
  end
  

  ## static pages
  get 'about-us',         to: "pages#about_us",         as: :about_us,        format: false
  get 'contact-us',       to: "pages#contact_us",       as: :contact_us,      format: false
  get 'terms',            to: "pages#terms",            as: :terms,           format: false
  get 'advertisers',      to: "pages#advertisers",      as: :advertisers,     format: false
  get 'help',             to: "pages#help",             as: :help,            format: false
  get 'privacy-policy',   to: "pages#privacy_policy",   as: :privacy_policy,  format: false
  get 'user-agreement',   to: "pages#user_agreement",   as: :user_agreement,  format: false

  ## dashboard
  #current resource :dashboard, only: [:show], format: false
  get   '/dashboard',               to: 'dashboards#show'
  get   '/group_feed',              to: 'dashboards#group_feed'
  get   '/message',                 to: 'dashboards#message'
  get   '/search',                  to: 'dashboards#search'
  get   '/people',                  to: 'dashboards#people'
  get   '/pictures',                to: 'dashboards#pictures'
  get   '/picture',                 to: 'dashboards#picture'
  get   '/friendrequests',          to: 'friendship#friend_requests'
  get   '/upload_picture',          to: 'dashboards#upload_picture'
  get   '/settings',                to: 'dashboards#settings'
  post   '/update_settings',        to: 'dashboards#update_settings'
  get   '/connect_facebook',        to: 'dashboards#connect_facebook'
  get   '/inbox',                   to: 'messages#inbox'
  ## landing page
  root to: 'home#index'
  
  get '/manual_signup',             to: 'home#manual'
  
  ## resources
  resources :events, only: [:new, :create, :show, :destroy] do
    post 'attend',         on: :member
    post 'not_attend',     on: :member
    post 'share_facebook', on: :member
    get 'all',        on: :collection
    get 'my',         on: :collection  
    get 'near_city',    on: :collection
    get 'near_region',  on: :collection
    get 'near_country', on: :collection
    get 'public',     on: :collection
    get 'search',     on: :collection
  end

  resources :places, only: :index do
    get 'people',     on: :collection
    get 'change_regions',     on: :collection
  end


  resources :groups, only: [:new, :create] do
    get 'mine',       on: :collection, as: :my
    get 'users',      on: :member
    get 'members',    on: :member
    get 'about',      on: :member
    get 'groupusers', on: :collection
    get 'moderate',   on: :collection
    get 'settings',   on: :member
    # get 'discussion', on: :member
    get 'popular', on: :collection
    get 'recent', on: :collection
    get 'search',     on: :collection
    get 'council', on: :member
    get 'latest_discussions', on: :member
    get 'latest_activities',  on: :member
    post 'share_facebook', on: :member
    post 'join_group',  to: 'membership#create'
    delete 'removes_member', to: 'membership#remove'
    put 'add_as_group_leader', to: 'membership#add_as_group_leader'
    put 'remove_from_group_leader', to: 'membership#remove_from_group_leader'
    put 'block', to: 'membership#block_from_group'
    
    resources :discussions, only: [:new, :create, :show, :update] do
      resources :comments do
        post 'like', on: :collection
        
      end
    end
    
    resources :settings, only: [:create, :update]
  end

  resources :interests, only: [:index, :show, :new] do
    get 'members',    on: :member
    get 'follow',    on: :member
    get 'unfollow',    on: :member
    get 'fetch_interests', on: :collection
  end

  resources :users, only: [:show] do 
    resource  :profile, only: [:show, :edit, :update]
    resources :messages, only: [:create]
    resources :pictures, only: [:index, :create, :show, :destroy, :update] do
      resources :comments do
        post 'like', on: :collection
        
      end
      get 'upload_picture',    on: :collection
    end
    resources :activities
    resources :update_statuses
    
    post   '/friend_request',  to: 'friendship#create'
    post   '/accept',  to: 'friendship#accept', as: 'friend_request_accept'
    post   '/ignore',  to: 'friendship#ignore', as: 'friend_request_ignore'
    post   '/decline',  to: 'friendship#decline', as: 'friend_request_decline'
    get    '/friend_requests', to: 'friendship#friend_requests'
    get    '/messages', to: 'messages#messages_with_user', as: 'related_messages'
    
  end

  resource :authorization, only: [:destroy] 
  
  resources :comments, only: [:destroy] do
    post 'flag', on: :collection
  end

  
  
  
end
