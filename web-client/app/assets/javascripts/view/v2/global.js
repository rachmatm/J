$('#main-registration-form').validate({
  rules: {
    'registration[username]': {
      required: true,
      username: true,
      minlength: 5
    },
    'registration[realname]': {
      required: true
    },
    'registration[email]': {
      required: true,
      email: true
    },
    'registration[password]': {
      required: true,
      minlength: 6
    }
  },
  messages: {},
  errorPlacement: function(error, element){
    var $alert_section = element.parents('tr').children('.main-registration-form-field-alert');

    $alert_section.children('.error').html(error).removeClass('hidden');
    $alert_section.children('.default_text').addClass('hidden');
  },
  success: function(label){
    var $alert_section = label.parents('.main-registration-form-field-alert');

    $alert_section.children('.error').addClass('hidden');
    $alert_section.children('.default_text').removeClass('hidden');
  },
  highlight: function(element, errorClass, validClass){
    var $el = $(element);
    $el.addClass(errorClass).removeClass(validClass);

    var $alert_section = $el.parents('tr').children('.main-registration-form-field-alert');

    $alert_section.children('.error').removeClass('hidden');
    $alert_section.children('.default_text').addClass('hidden');
  },
  unhighlight: function(element, errorClass, validClass){
    var $el = $(element);
    $el.removeClass(errorClass).addClass(validClass);

    var $alert_section = $el.parents('tr').children('.main-registration-form-field-alert');

    $alert_section.children('.error').addClass('hidden');
    $alert_section.children('.default_text').removeClass('hidden');
  }
});

// Notification AJAX

$('.update_close').hide();
$('.notif_info_content_more').hide();

$('.more_update_display').click(function(){
  var more_id = new String ( $(this).attr('id') );
  $('.notif_' + more_id + ' .notif_info_content_more').toggle();
  $('.notif_' + more_id + ' .notif_info_content_less').toggle();
  $(this).html(($(this).html() == 'more') ? 'less' : 'more');
});

$('.notif_information').mouseover(function(){
  $(this).find('.update_close').show();
}).mouseout(function(){
  $('.update_close').hide();
});

$('.update_close').live('click', function(){
  var notif_id = new String ( $(this).attr('id') );
  $.ajax({
    url: '/notification/' + notif_id + '/destroy.json',
    type: 'GET',
    success: function(data, textStatus, jqXHR){
      if(data.failed === true){
        alert(data.error);
      }
      else{
        $('.notif_' + notif_id).hide(850, function(){
          $(this).remove();
          $('span.update_text').html($('.notif_information').length + ' New Updates');
        });
      }
    },

    error: function(jqXHR, textStatus, errorThrown){
      alert("Deleting notification failed: " + textStatus);
    }
  });
  return false;
});

$('.clear_all_you').live('click', function(){
  $.ajax({
    url: '/notification/all/destroy.json',
    type: 'get',
    data: {type: 'user'},
    success: function(data, textstatus, jqxhr){
      if(data.failed === true){
        alert(data.error);
      }
      else{
        $('.notif_new_update_you li').hide(850, function(){
          $(this).remove();
          $('span.update_text').html($('.notif_information').length + ' new updates');
        });
      }
    },

    error: function(jqxhr, textstatus, errorthrown){
      alert("deleting notification failed: " + textstatus);
    }
  });
  return false;
});

$('.clear_all_jot').live('click', function(){
  $.ajax({
    url: '/notification/all/destroy.json',
    type: 'get',
    data: {type: 'jot'},
    success: function(data, textstatus, jqxhr){
      if(data.failed === true){
        alert(data.error);
      }
      else{
        $('.notif_new_update_jot li').hide(850, function(){
          $(this).remove();
          $('span.update_text').html($('.notif_information').length + ' new updates');
        });
      }
    },

    error: function(jqxhr, textstatus, errorthrown){
      alert("deleting notification failed: " + textstatus);
    }
  });
  return false;
});
