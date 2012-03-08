class ForgotPassword < Mailer

  def self.forgot_password_email(params)
    Pony.mail(:to => params[:user].email,
              :body => Mailer.render_with_template( :file => Mailer.root_path('views/forgot_password/forgot_password_email.html.erb'), :locals => params),
              :subject => "Password Verification")
  end
end
