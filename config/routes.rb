Rails.application.routes.draw do
  # root route --> direct requests for /
  root "static_pages#home"

  # maps GET http request URL/static_pages/home to home action in Static Pages controller
  get 'static_pages/home'

  get 'static_pages/help'

  get "static_pages/about" # adding this line of code automatically created static_pages_about_url helper

  get "static_pages/contact"
end
