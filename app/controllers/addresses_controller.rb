class AddressesController < ApplicationController
  def new
    # Renders the form for address input
  end

  def create
    # Redirect to the WeatherController's show action with address parameters
    redirect_to weather_path(street: params[:street], state: params[:state], zip_code: params[:zip_code])
  end
end
