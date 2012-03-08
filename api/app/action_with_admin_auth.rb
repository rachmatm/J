class ActionWithAdminAuth < Action  
  before_start :validate_auth_admin
  
  def validate_auth_admin
    if self.auth_admin.availibility_check?
      yield
    else
      halt 303, {'Location' => '/lord/login'}
    end
  end
end