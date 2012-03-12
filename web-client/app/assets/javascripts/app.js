$('#link-to-registration').bind('click', function(){
  $('.main-content-listing').addClass('hidden');
  var registrationFormView = new RegistrationFormView;
});

var magicBoxView = new MagicBoxView;