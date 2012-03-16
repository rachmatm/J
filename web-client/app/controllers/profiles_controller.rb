class ProfilesController < ApplicationWithTokenController
  def update
    respond_to do |format|
      format.json do
        if params['user']['bio'].present? and  @current_user.update_attribute 'bio', params['user']['bio']
          result = @current_user.bio
        elsif params['user']['url'].present? and  @current_user.update_attribute 'url', params['user']['url']
          result = @current_user.url
        elsif params['user']['location'].present? and  
          @current_user.update_attributes :location => params['user']['location'], :latitude => params['user']['latitude'],
          :longitude => params['user']['longitude']
          result = @current_user.location  
        else
          result = @current_user.errors.to_a.join(', ')
        end
        
        render :json => { :result => result }
      end  
      format.all { respond_not_found }
    end
  end
end
