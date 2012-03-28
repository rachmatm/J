class ProfilesController <  ApplicationController
  layout 'application3'
  before_filter :validate_auth_user
  
  def show
    data = api_connect('me.json', params[:profile], 'get', false, true)
    @profile = data['content']
  end

  def edit
    data = api_connect('me.json', params[:profile], 'get', false, true)
    @profile = data['content']
  end
 
  def update
    respond_to do |format|
      format.json do
        render :json =>  api_connect('me.json', params[:profile], 'post', false, true)
      end

      format.html do
        data = api_connect('me.json', params[:profile], 'post', false, true)

        if data['failed'] === true
          flash[:error] = data['error']
          flash[:errors] = data['errors']
          render 'edit'
        else
          flash[:notice] = data['notice']
          redirect_to edit_profiles_path
        end
      end
      
      format.all { respond_not_found }
    end
  end
end
