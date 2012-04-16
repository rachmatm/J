window.currentUserTwoModel = new CurrentUserTwoModel;

$(window).bind('auth:login', function(e, data, token, attributes){
  currentUserTwoModel.setData(data, token, attributes, true);
  location.href = '#!/jots';
});

$(window).bind('auth:logout', function(){
  currentUserTwoModel.unsetData();
  location.href = '#!/jots';
});

window.appRouter = new AppRouter;
appRouter.render();

//window.CurrentUser = CurrentUserModel.extend({
//
//  after_login: function(data, token){
//
//    appRouter.render({
//      current_user: currentUser.data(),
//      current_user_token: currentUser.token()
//    });
//
//    if(data.username){
//      location.href = '#!/jots';
//    }
//  },
//
//  after_logout: function(data, token){
//    appRouter.render({
//      current_user: currentUser.data(),
//      current_user_token: currentUser.token()
//    });
//    location.href = '#!/jots';
//  }
//});
//
//window.currentUser = new CurrentUser;
//currentUser.setAuth();
//
//if(currentUser.token() && _.isEmpty(currentUser.data())){
//  currentUser.setProfile(currentUser.token(), true);
//}
//
//appRouter.render({
//  current_user: currentUser.data(),
//  current_user_token: currentUser.token()
//});

Backbone.history.start();

$(function(){
  if(localStorage.auth_error){
    $.colorbox({
      html: globalTemplateModalBoxInfo({
        message: localStorage.auth_error
      }),
      onComplete: function(){
        $.colorbox.resize();
      }
    });

    localStorage.removeItem('auth_error');
  }
});


window.globalTemplateModalBoxInfo = _.template($('#prompt-info-template').html());
window.globalAlertView = new AlertView;
window.globalHolderView = new HolderView;

$('form').live('xhr:submit:before', function(e, form){

  $(form).find('input, textarea').attr({
    disabled: 'disabled'
  });

  $('#main-loader').animate({
    height: 30
  });
});

$('form').live('xhr:submit:error', function(e, form, textStatus){
  $.colorbox({
    html: globalTemplateModalBoxInfo({
      message: textStatus
    }),
    onComplete: function(){
      $.colorbox.resize();
    }
  });
});

$('form').live('xhr:submit:success', function(e, form, alertEl, data){
  $('#main-loader').animate({
    height: 0
  });
  $(form).find('input, textarea').removeAttr('disabled');

  globalAlertView.remove();
  if(data.failed === true){
    globalHolderView.setElement(alertEl);
    globalHolderView.render({
      className: 'holder-view-alert'
    });

    globalAlertView.setElement(globalHolderView.holder_el);
    globalAlertView.render({
      error: data.error,
      errors: data.errors
    });
  }
});

//---------- 2
$('form').live('xhr:submit:before:two', function(e, form){
  $(form).find('input, textarea').attr({
    disabled: 'disabled'
  });

  $(form).find('input[type=submit]').addClass('before-submit-button')
});


$('form').live('xhr:submit:success:two', function(e, form, alertEl, data){
  $('#main-loader').animate({
    height: 0
  });
  $(form).find('input, textarea').removeAttr('disabled');
  $(form).find('input[type=submit]').removeClass('before-submit-button')

  globalAlertView.remove();
  if(data.failed === true){
    globalHolderView.setElement(alertEl);
    globalHolderView.render({
      className: 'holder-view-alert'
    });

    globalAlertView.setElement(globalHolderView.holder_el);
    globalAlertView.render({
      error: data.error,
      errors: data.errors
    });
  }
});