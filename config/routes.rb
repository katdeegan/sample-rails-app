Rails.application.routes.draw do
  get 'session/new'
  get 'users/new'
  # root route --> direct requests for /
  root "static_pages#home"

  # define named routes explicitly
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about" # adding this line of code automatically created static_pages_about_url helper
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "/login", to: "session#new" # named route: login_path
  post "/login", to: "session#create" # named route: login_path
  delete "/logout", to: "session#destroy" # named route: logout_path


  # routing for /users/id
  # :resources method results in the full suite of RESTful routes
  resources :users
end
