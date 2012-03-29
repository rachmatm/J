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

// Search AJAX

$('#search-form').ajaxForm({
  dataType: 'json',
  error: function(jqXHR, textStatus, errorThrown){
    alert(textStatus);
  },
  success: function(data, textStatus, jqXHR){
    if(data.failed === true){
      alert(data.error);
    }
    else{
      console.log(data.content)
      console.log(data.content.length)
      $('#main-welcome').html(data.content);
    }
  }
});

$('.search_resultsContent').delegate('li', 'click', function(){
  $('.search_resultsContent li').toggle(function(){

    // Appending whitespace so it is a little more proper
    var tag_name = $(this).find('.choice_text').html() + ' ';
    var breadcrumb_name = $(this).find('.choice_text').html();

    // Testing the input box for whitespace at end of line
    if (!(/\s$/).test($('#jot-search-field').val()) && !($('#jot-search-field').val() == '')) {
      tag_name = ' ' + tag_name;
    }

    // Appending clicked tag
    $('#jot-search-field').val($('#jot-search-field').val() + tag_name);

    // Changing the appearance according to the state
    $(this).find('.not_active').addClass('activeSearch');
    $(this).find('.choice_text').addClass('active_choiceTexts');

    // Appending to the breadcrumb
    if ($('.breadcrumb_search').find('a').length > 0) {
      $('.breadcrumb_search li').append('<span class="tag_' + breadcrumb_name +
                                        '">&gt; </span><a class="tag_' + breadcrumb_name +
                                        '" href="">' + breadcrumb_name + '</a>');
    } else {
      $('.breadcrumb_search li').append('<a class="tag_' + breadcrumb_name +
                                        '" href="">' + breadcrumb_name + '</a>');
    }

  }, function(){

    // Appending whitespace so it is a little more proper
    var tag_name = $(this).find('.choice_text').html() + ' ';

    // Testing the input box for whitespace at end of line
    if (!(/\s$/).test($('#jot-search-field').val())) {
      tag_name = ' ' + tag_name;
    }

    // Setting up proper regex capture and replacing
    // the old value in the input box with the new one
    var tag_regex = new RegExp("(.*)" + tag_name + "(.*)");
    var tag_replace = $('#jot-search-field').val().replace(tag_regex, '$1$2');

    // Deleting clicked tag
    $('#jot-search-field').val(tag_replace);

    // Changing the appearance according to the state
    $(this).find('.not_active').removeClass('activeSearch');
    $(this).find('.choice_text').removeClass('active_choiceTexts');

    $('.tag_' + $(this).find('.choice_text').html()).remove();
  });
});

function rebindcontent() {
  $('.r-people-result-dropdwn-item').click(function(){
    console.log('cool');
    $('#jot-search-field').val('@' + $($(this).find('.dropdwn_content_text')).html());
    $('#r-people-result-dropdwn').hide();
    $('#jot-search-field').focus();
  });
}

$('#jot-search-field').each(function() {

  // Save current value of element
  $(this).data('oldVal', $(this).val());

  // Look for changes in the value
  $(this).bind("propertychange input paste", function(event){

    // If value has changed...
    if ($(this).data('oldVal') != $(this).val() && $(this).val().length > 1) {

      // Updated stored value
      $(this).data('oldVal', $(this).val());

      if ($(this).val().match(/^@.*/) && !$(this).val().match(/\s/)) {
        $('.search_box_from_nest').hide();
        $('#r-people-result-dropdwn').show();

        // Send the request
        $.ajax({
          url: '/search/get_user.json',
          type: 'GET',
          dataType: 'json',
          data: 'text=' + $(this).val(),

          // Action taken if the request is successful
          success: function (data, textStatus, jqXHR) {
            if (data.failed === true) {
              alert(data.error);
            } else {
              var new_users = "";

              // Parse each result that comes in and put
              // it in the appropriate place
              $.each($.parseJSON(data.content), function(index, value){
                new_users = new_users +
                            '<li>' +
                            '<a class="r-people-result-dropdwn-item" href="#">' +
                            '<span class="dropdwn_content_photo">' +
                            '<img alt="" src="/assets/ava-farrukh.png">' +
                            '</span>' +
                            '<span class="dropdwn_content_text">'+ value.username +'</span>' +
                            '</a>' +
                            '</li>'
              });

              console.log(new_users);
              // Appending the tags to its appropriate level
              $('.result_dropdwn_content > ul').html(new_users);
              rebindcontent();
            }
          }
        });
      } else {
      // Do action
      $('.search_box_from_nest').show();
      $('#r-people-result-dropdwn').hide();

      // Send the request
      $.ajax({
        url: '/search/get_tag.json',
        type: 'GET',
        dataType: 'json',
        data: 'text=' + $(this).val(),

        // Action taken if the request is successful
        success: function (data, textStatus, jqXHR) {
          if (data.failed === true) {
            alert(data.error);
          } else {
            var new_tags = "";

            // Parse each result that comes in and put
            // it in the appropriate place
            $.each($.parseJSON(data.content), function(index, value){
              if ($(new_tags).length < 5) {
                new_tags = new_tags + '<li class="Lev_1"><span class="choice_text">' + value.name + '</span><span class="not_active"></span></li>'
              } else if ($(new_tags).length >= 5 && $(new_tags).length < 10) {
                new_tags = new_tags + '<li class="Lev_2"><span class="choice_text">' + value.name + '</span><span class="not_active"></span></li>'
              } else {
                new_tags = new_tags + '<li class="Lev_3"><span class="choice_text">' + value.name + '</span><span class="not_active"></span></li>'
              }
            });

            // Wrap the new_tags variable so it can
            // run the find() method properly
            new_tags = '<div>' + new_tags + '</div>'

            // Appending the tags to its appropriate level
            $('.search_resultsContent > div.level_1 > ul').html($(new_tags).find('.Lev_1'));
            $('.search_resultsContent > div.level_2 > ul').html($(new_tags).find('.Lev_2'));
            $('.search_resultsContent > div.level_3 > ul').html($(new_tags).find('.Lev_3'));
          }
        }
      });
    }

    } 
    if ($(this).val().length < 2 || $(this).val() == "") {
      $('.search_box_from_nest').hide();
      $('#r-people-result-dropdwn').hide();
    }
  });
});
