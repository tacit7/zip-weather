Rails.application.routes.draw do
  root "addresses#new"   # The root path renders the form
  get  "addresses/new", to: "addresses#new",    as: "new_address"
  post "addresses",     to: "addresses#create", as: "addresses"
  get  "weather/show",  to: "weather#show",     as: "weather"
  get  "about",         to: "about#show"
end
