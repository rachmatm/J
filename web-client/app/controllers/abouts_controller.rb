class AboutsController < ApplicationController
  def show
    if @current_user.present?
      
       render :show , :layout => 'private2'
    else
       render :show , :layout => 'application2'
    end
    
  end
end