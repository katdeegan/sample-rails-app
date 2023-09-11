Rails.application.routes.draw do
  get 'users/new'
  # root route --> direct requests for /
  root "static_pages#home"

  get "/help", to: "static_pages#help"

  get "/about", to: "static_pages#about" # adding this line of code automatically created static_pages_about_url helper

  get "/contact", to: "static_pages#contact"

  get "/signup", to: "users#new"
end
