module HttpResponseAction

  class Error404 < Action
    def start
      render JsonizeHelper.format({:status => 404, :status_text => "Not Found", :failed => true, :error => "Oops, Data Provider didn't catch your request"})
      finish
    end
  end
end