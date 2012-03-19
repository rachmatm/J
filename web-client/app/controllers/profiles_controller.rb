class ProfilesController < ApplicationWithTokenController
  def update
    respond_to do |format|
      format.json do
        if params['user']['username'].present? or params['user']['realname'].present?
          profile_update_response = api_connect('profile/update', { :username => params['user']['username'], :realname => params['user']['realname'] }, 'post', false, true)
        elsif params['user']['bio'].present?
          profile_update_response = api_connect('profile/update', { :bio => params['user']['bio'] }, 'post', false, true)
        elsif params['user']['url'].present?
          profile_update_response = api_connect('profile/update', { :url => params['user']['url'] }, 'post', false, true)
        elsif params['user']['location'].present?
          parameters = { :location => params['user']['location'], :latitude => params['user']['latitude'], :longitude => params['user']['longitude'] }
          profile_update_response = api_connect('profile/update', parameters, 'post', false, true)
        else
          render :json => { :error => "Invalid entry" }
        end

        render :json => profile_update_response
      end
      format.all { respond_not_found }
    end
  end
end
