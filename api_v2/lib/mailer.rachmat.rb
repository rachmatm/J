require 'mailfactory'

class Mailer

  DEFAULTS = {
    :to =>  "rachmat.maulana@digitmediaworld.com",
    :from => "rachmat.maulana@digitmediaworld.com",
    :subject => "Jotky Mailer",
    :port => 587,
    :domain => 'jotky.com',
    :auth => {
      :type => :plain,
      :username => "rachmat.maulana@digitmediaworld.com",
      :password => "Johnny55"
    },
    :host => 'smtp.gmail.com',
    :starttls => true,
    :verbose => true
  }


  def initialize(options = {})
    @options = DEFAULTS.merge options

    @mail = MailFactory.new()

    @locals = {
      site_url: Server::Application.url,
      assets_url: File.join(Server::Application.url, Server::Application.routes.url(:assets), 'images', 'email')
    }
  end

  def reset_password_notification(options = {}, locals = {})

    @mail.to = @options[:to]
    @mail.from = @options[:form]
    @mail.subject = "Password Recovery"
    @mail.text = ""
    @mail.html = template(Server::Application.root('views/mailer/reset_password_confirmation.html.erb'), @locals.merge(locals))
    
    email = EM::Protocols::SmtpClient.send @options.merge(:content => "#{@mail.to_s}\r\n.\r\n")

    email.errback{ |e|
      Cramp.logger.error e
    }
  end

  def template(params, locals)
    Tilt.register Tilt::ERBTemplate, 'bar'
    
    template = Tilt.new params
    template.render Object.new, locals
  end
end
