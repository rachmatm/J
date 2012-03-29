class Action < Cramp::Action

  def html_header(format = nil)
    {"Content-Type" => "#{MIME::Types.type_for(format || params[:format] || '').first}" || "text/html"}
  end

  def respond_with
    [200, html_header]
  end

  def render_with_template(params)
    template = Tilt.new params[:file]
    render template.render Object.new, params[:locals]
  end

  def root_path(path = nil)
    Server::Application.root path
  end

  protected
  
  def handle_exception(exception)
    handler = Cramp::ExceptionHandler.new(@env, exception)
    # Log the exception
    unless ENV['RACK_ENV'] == 'test'
      exception_body = handler.dump_exception
      Cramp.logger ? Cramp.logger.error(exception_body) : $stderr.puts(exception_body)
    end

    case @_state
      when :init
        halt 500, html_header, JsonizeHelper.format({:status => 500, :status_text => "Data Provider Error"})
      else
        render JsonizeHelper.format({:status => 500, :status_text => "Internal Server Error", :error => "Data Provider Error", :failed => true})
        finish
      end
  end
end