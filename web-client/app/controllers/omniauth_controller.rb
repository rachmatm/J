class OmniauthController < ApplicationController
  def google
    redirect_to BASE_URL + "omniauth/google?app_id=#{APP_ID}&secret_key=#{APP_SECRET}"
  end

  def authenticate_google
    if params[:jotky_token].present?
      set_token({:key => params[:jotky_token]})
      redirect_to root_path, :notice => "#{ params[:username] }, you have authenticated your Youtube account"
    else
      redirect_to root_path, :notice => params[:notice]
    end
  end
end
