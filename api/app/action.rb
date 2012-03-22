class Action < Cramp::Action
  before_start :declare_auth_admin, :declare_flash_session
  attr_accessor :auth_admin, :flash_session

  def respond_with
    [200, get_content_type]
  end

  def get_content_type
    {'Content-Type' => "text/html", "Cache-Control" => "max-age=0, private, must-revalidate", "Date" => "Wed, 21 Mar 2012 20:31:53 GMT"}
  end

  # Params
  # Hash[:File] = template file path
  # Hash[:locals] = Hash - data
  def render_with_template(params)
    Tilt.register Tilt::ERBTemplate, 'bar'

    template = Tilt.new params[:file]
    render template.render Object.new, params[:locals]
  end

  # Params
  # String(next_path) = next path after root
  def root_path(next_path)
    Server::Application.root next_path
  end

  def declare_auth_admin
    self.auth_admin = AuthHelper.new request.session, 'admin'
    yield
  end

  def declare_flash
    self.flash = FlashHelper.new request.session
    yield
  end

  def start_with_validates_params(allowed_params, &block)
    @parameters = Hash.new

    allowed_params.each do |allowed|
      @parameters[allowed] = params[allowed] if params[allowed].present?
    end

    if @parameters.present?
      render yield
    else
      render JsonizeHelper.format( :status => 401, :error => "You need to fill at least one field", :failed => true ) 
    end

    finish
  end

  def declare_flash_session
    self.flash_session = Flash.new request.session
    yield
  end

  def set_flash(params = {})
    self.flash_session.set(params)
  end

  def flash
    self.flash_session.get
  end
end
