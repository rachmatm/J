class AuthHelper
  
  def initialize(session, key)
    @key_id = "#{key}_id".parameterize.underscore.to_sym
    @key_last_login = "#{key}_last_login".parameterize.underscore.to_sym
    @session = session
  end  
   
  def login(id)
    @session[@key_last_login] = Time.now
    @session[@key_id] = id
  end
  
  def logout!
    @session[@key_id] = nil
  end
  
  def availibility_check?
    if @session[@key_id].present? and 15.minutes.from_now(@session[@key_last_login]) > Time.now
      @session[@key_last_login] = Time.now
      return true
    else
      logout!
      return false
    end  
  end
end