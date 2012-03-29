class Flash
  def initialize(session)
    @session = session
    
    #@session[:flash] ||= Hash.new
  end

  def set(params = {})
    @session.merge!(params)
  end

  def get
    @session
  end
end