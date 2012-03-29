require 'pony'

class Mailer
  Pony.options = {
    :from => "rachmat.maulana@digitmediaworld.com",
    :headers => { 'Content-Type' => 'text/html'},
    :via => :smtp,
    :via_options => {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "digitmediaworld.com",
      :user_name            => "rachmat.maulana@digitmediaworld.com",
      :password             => "Johnny55",
      :authentication       => "plain",
      :domain               => "localhost.localdomain",
      :enable_starttls_auto => true
    }
  }

  # Params
  # Hash[:File] = template file path
  # Hash[:locals] = Hash - data
  def self.render_with_template(params)
    Tilt.register Tilt::ERBTemplate, 'bar'
    
    template = Tilt.new params[:file]
    return template.render Object.new, params[:locals]
  end

  # Params
  # String(next_path) = next path after root
  def self.root_path(next_path)
    Server::Application.root next_path
  end
end
