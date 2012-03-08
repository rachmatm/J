function validateUsername() {
  var reg_user_value = $.trim($("#reg_user").val());
  if ( reg_user_value === '' ) {
    $("p", "#alert_username").addClass('hidden');
    $("#ins_username_empty").removeClass('hidden');
  }
  else if ( reg_user_value === 'donny' ) {
    $("p", "#alert_username").addClass('hidden');
    $("#ins_username_taken").removeClass('hidden');
  }
  else {
    $("p", "#alert_username").addClass('hidden');
    $("#ins_username_accepted").removeClass('hidden');
  }
}

function validateRealname() {
  var reg_name_value = $.trim($("#reg_name").val());
  if ( reg_name_value === '' ) {
    $("p", "#alert_realname").addClass('hidden');
    $("#ins_realname_empty").removeClass('hidden');
  }
  else {
    $("p", "#alert_realname").addClass('hidden');
  }
}

function validateEmail() {
  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  var reg_email_value = $.trim($("#reg_email").val());
  if ( reg_email_value === '' || ! reg_email_value.match(re) ) {
    $("p", "#alert_email").addClass('hidden');
    $("#ins_email_error").removeClass('hidden');
  }
  else {
    $("p", "#alert_email").addClass('hidden');
    $("#ins_email_accepted").removeClass('hidden');
  }
}

function validatePassword() {
  var best_password = /^.*(?=.{6,})(?=.*[A-Z])(?=.*[\d])(?=.*[\W]).*$/;
  var reg_pass_value = $.trim($("#reg_pass").val());
  if ( reg_pass_value === '' ) {
    $("p", "#alert_password").addClass('hidden');
    $("#ins_password_empty").removeClass('hidden');
  }
  else if ( ! best_password.test(reg_pass_value) ) {
    $("p", "#alert_password").addClass('hidden');
    $("#ins_password_error").removeClass('hidden');
  }
  else {
    $("p", "#alert_password").addClass('hidden');
    $("#ins_password_accepted").removeClass('hidden');
  }
}

function heal() {
  $('span.triangle').removeClass('searchActive');
}

function showhide(show){
  $("#"+show).toggle("slideDown").next("");
}

jQuery(function($){
  /* -- TINY SCROLLBAR -- */
  $('#scrollbar1').tinyscrollbar();	
  
  /* -- REGISTRATION VALIDATION -- */
  $("#registration").bind('click', function(e){
    e.preventDefault();
    validateUsername();
    validateRealname();
    validateEmail();
    validatePassword();
  });
  $("#reg_user").bind('keyup', function(){
    validateUsername();
  });
  $("#reg_name").bind('keyup', function(){
    validateRealname();
  });
  $("#reg_email").bind('keyup', function(){
    validateEmail();
  });
  $("#reg_pass").bind('keyup', function(){
    validatePassword();
  });
  
  /* -- REPLACE SEARCH CONTENT TO SIGN IN CONTENT -- */
  $(".login_content").hide();
  $("#signUp").click(function(){
    $(this).addClass('login');
    $(".search").hide();
    $(".side-left").hide();
    $(".search_tab").hide();    
    $(".searchResult_content_logged").hide();
    $(".login_content").show();
    $(".welcome_content").show();
    return false
  });
  
  /* -- REPLACE MIDLE CONTENT LANDING PAGE CONTENT TO SIGN UP CONTENT -- */
  $(".signUp_content").hide();
  $("#green_signUp").click(function(){
    $(".middle_content").hide();    
    $(".signUp_content").show();
    return false
  });
  
  /* -- REPLACE MIDLE CONTENT LANDING PAGE CONTENT TO SEARCH CONTENT -- */
  $(".search_tab").hide();
  $(".searchResult_content").hide();
  $("#gray_search").click(function(){
    $(".middle_content").hide();    
    $(".search_tab").show();
    $(".searchResult_content").show();
    return false
  });
  
  /* -- REPLACE MIDLE CONTENT LANDING PAGE CONTENT TO SEARCH CONTENT -- */
  $(".searchResult_content_logged").hide();
  $(".side-left").hide();
  $("#gray_search").click(function(){
    $(".middle_content").hide();    
    $(".searchResult_content_logged").show();
    $(".side-left").show();
    return false
  });
  
  $('.choice_text').click(function(){
    $(this).toggleClass('active_choiceText');
  });
  
  $('.not_active').click(function(){
    $(this).toggleClass('icon_notActive');
  });
  
  $('.button_tagText').click(function(){
    $(this).toggleClass('active_tagResult');
  });
  
  $('.not_activeSearch').click(function(){
    $(this).toggleClass('activeSearch');
  });
   
  $('li.leftMenu_searchResult').bind('mouseover', function(){
    $(this).children().siblings().removeClass('searchActive');
    $(this).children().toggleClass('searchActive');
  });
  
  $(".fav_hover").hide();
  $('.portlet_favValue_logged').mouseover(function(){
    $(this).addClass('onhover');
  }).mouseout(function(){
    $(this).removeClass('onhover');
  });
  
  $('.nest_group_middle_active').hide();
  $('.on_off').click(function(){
    $(this).toggleClass('on_off_active');
    $(this).siblings('.category_name').toggleClass('online_text');
    $(this).siblings('.nest_group_middle_active').toggle();
    $(this).siblings('.nest_group_middle_notactive').toggle();
  });
  
  $('.on_off_top').click(function(){
    $(this).toggleClass('on_off_active_top');
    $('.count_nest').toggleClass('online_text');
  });
  
  $('.down_arrow').click(function(){
    $(this).toggleClass('up_arrow');
  });
  
  $(".people_postNonLogin").hide();
  $('.people_post').mouseover(function(){
    $(this).addClass('header_hover');
  }).mouseout(function(){
    $(this).removeClass('header_hover');
  });
   
  $("#movies_child_category").hide();
  $("#tech_child_category").hide();
  $("#graphic_child_category").hide();
  $("#fhm_child_category").hide();
  
  $('.pub_profile_link').click(function(){
    $(this).addClass('bottom_links_active');
    $('.account_setting_link').removeClass('bottom_links_active');
    return false;
  });
  
  $('.account_setting_link').click(function(){
    $(this).addClass('bottom_links_active');
    $('.pub_profile_link').removeClass('bottom_links_active');
    return false;
  });
  
  $(".parent_empty_profile").hide();
  $("#user_logged").click(function(){
    $(".middle_content").hide();
    $(".search").hide();
    $(".side-left").hide();
    $(".search_tab").hide();
    $(".jot_buttons_path").hide();
    $(".parent_empty_profile").show();
    return false
  });
  
  $('a[rel*=facebox]').facebox({
    loadingImage : '../images/loading.gif',
    closeImage   : '../images/closelabel.png'
  })
  
  $('.empty_bio_field').hide();
  $('.empty_bio_text').click(function(){
    $('.empty_bio_field').show();
    $('.empty_bio_text').hide();
    return false;
  });
  
  $('.empty_url').hide();
  $('.empty_url_text').click(function(){
    $('.empty_url').show();
    $('.empty_url_text').hide();
    return false;
  });
  
  $('.empty_location_field').hide();
  $('.empty_location_text').click(function(){
    $('.empty_location_field').show();
    $('.empty_location_text').hide();
    return false;
  });
  
  $('.map_area').hide();
  $('#location_field').click(function(){
    $('.map_area').show();
    return false;
  });
  
  $('.add_own_location').click(function(){
    $('.map_area').toggle();
    return false;
  });
  
  $('.acc_setting_tab').hide();
  $('.account_setting_link').click(function(){
    $('.acc_setting_tab').toggle('slow'); 
    return false;
  });
  
  $('.nest_magnifier_icon').hide();
  $('.hover_magnifier').mouseover(function(){
    $(this).find('.nest_magnifier_icon').show();
  }).mouseout(function(){
    $(this).find('.nest_magnifier_icon').hide();
  });
  
  $('.drag_box_bottom').hide();
  $('#drag_box_jot_treat').mouseover(function(){
    $('.drag_box_bottom').show();
  }).mouseout(function(){
    $('.drag_box_bottom').hide();
    return false;
  });
  
  $('.drag_box_bottom').hide();
  $('#drag_box_user_treat').mouseover(function(){
    $('.drag_box_bottom').show();
  }).mouseout(function(){
    $('.drag_box_bottom').hide();
    return false;
  });
  
  $('.faq_description').hide();
  $('.faq_content_toggle').click(function(){
    $(this).siblings('.faq_description').toggle();
    return false;
  })
  
  $('.about_default').click(function(){
    $(this).addClass('about_active');
    $('.what_jotky_default').removeClass('about_active');
    $('.faq_default').removeClass('about_active');
    $('.about_jotky').show();
    $('.what_jotky').hide();
    $('.faq_jotky').hide();
    return false;
  });
  
  $('.what_jotky_default').click(function(){
    $(this).addClass('about_active');
    $('.about_default').removeClass('about_active');
    $('.faq_default').removeClass('about_active');
    $('.what_jotky').show();
    $('.about_jotky').hide();
    $('.faq_jotky').hide();
    return false;
  });
  
  $('.faq_default').click(function(){
    $(this).addClass('about_active');
    $('.what_jotky_default').removeClass('about_active');
    $('.about_default').removeClass('about_active');
    $('.faq_jotky').show();
    $('.what_jotky').hide();
    $('.about_jotky').hide();
    return false;
  });
  
  $('.about_bottom_link').click(function(){
    $('.about_jotky').show();
    $('.what_jotky').hide();
    $('.faq_jotky').hide();
    return false;
  });
  
  $('.what_jotky_bottom_link').click(function(){
    $('.what_jotky').show();
    $('.about_jotky').hide();
    $('.faq_jotky').hide();
    return false;
  });
  
  $('.faq_bottom_link').click(function(){
    $('.faq_jotky').show();
    $('.what_jotky').hide();
    $('.about_jotky').hide();
    return false;
  });
  
  $('.what_jotky').hide();
  $('.faq_jotky').hide();
  
  $('.reply_message_path').hide();
  $('.message_path').click(function(){
    $(this).siblings('.reply_message_path').toggle();
    return false;
  })
  
  $('.action_menu_hide').hide();
  $('.messages_down_arrow').click(function(){
    $(this).siblings('.action_menu_hide').toggle();
    $(this).toggleClass('messages_up_arrow');
    return false;
  })
  
  $('.compose_message_form').hide();
  $('.compose_new_message').click(function(){
    $(this).addClass('compose_new_message_active');
    $(this).siblings('.compose_message_form').toggle();
    return false;
  });
  
  $(".hot_jot_hover").hide();
  $('.hot_jot').mouseover(function(){
    $(this).addClass('stuff_hover');
  }).mouseout(function(){
    $(this).removeClass('stuff_hover');
  });
  
  $('.previous').hide();
  $('.previous_icon').mouseover(function(){
    $(this).find('.previous').show();
  }).mouseout(function(){
    $(this).find('.previous').hide();
  });
  
  $('.next').hide();
  $('.next_icon').mouseover(function(){
    $(this).find('.next').show();
  }).mouseout(function(){
    $(this).find('.next').hide();
  });
  
  $("a[rel='image_popup']").colorbox();
  $("#click").click(function(){ 
    $('#click').css({
      "background-color":"#f00",
      "color":"#fff",
      "cursor":"inherit"
    }).text("Open this window again and this message will still be here.");
    return false;
  });
  
  $(".jot_hover").hide();
  $('.jot_buttons_color').mouseover(function(){
    $(this).addClass('jot_hover');
  }).mouseout(function(){
    $(this).removeClass('jot_hover');
  });

  $(".jot_click").hide();
  $('.jot_buttons_color').click(function(){
    $(this).toggleClass('jot_click');
    $(this).toggleClass('jot_click_active');
  });
  
  $(".jot_down_arrow_hover").hide();
  $('.jot_buttons_color').mouseover(function(){
    $(this).addClass('jot_down_arrow_hover');
  }).mouseout(function(){
    $(this).removeClass('jot_down_arrow_hover');
  });
  
  $('.jot_more_content').hide();
  $('.jot_upload_media').hide();
  $('.jot_add_location').hide();
  $('.jot_tags_post').hide();
  $('.jot_green_bg').hide();
  $('.jot_down_arrow').click(function(){
    $(this).toggleClass('jot_up_arrow');
    $('.jot_more_content').toggle();
    $('.jot_mode_hide').toggleClass('show_more');
    $('.jot_upload_media').toggle();
    $('.jot_mode_hide').toggleClass('show_upload');
    $('.jot_add_location').toggle();
    $('.jot_mode_hide').toggleClass('show_add');
    $('.jot_tags_post').toggle();
    $('.jot_mode_hide').toggleClass('show_tags');
    return false;
  });
  
  $('.write_more_but').click(function(){
    $('.jot_buttons_color').toggleClass('jot_buttons_active');
    $('.jot_more_content').toggle();
    $('.jot_mode_hide').toggleClass('show_more');
    return false;
  });
  
  $('.jot_but').click(function(){
    $('.jot_upload_media').toggle();
    $('.jot_mode_hide').toggleClass('show_upload');
    return false;
  });
  
  $('.loc_but').click(function(){
    $('.jot_add_location').toggle();
    $('.jot_mode_hide').toggleClass('show_add');
    return false;
  });
  
  $('.tags_but').click(function(){
    $('.jot_tags_post').toggle();
    $('.jot_mode_hide').toggleClass('show_tags');
    return false;
  });
  
  $('.jot_result').hide();
  $('.jot_green_bg').click(function(){
    $('.jot_result').show('slow');
    $('.empty_stream').hide();
    $('.timeline_jot_path').hide();
    $('.jot_mode_hide').hide('slow');
    return false;
  });
  
  $('.image_upload_input').hide();
  $('.img_tittle').click(function(){
    $(this).siblings('.image_upload_input').show();
    $('.img_tittle').hide();
    return false;
  });
  
  $('.tittle_location').click(function(){
    $(this).siblings('.image_upload_input').show();
    $('.tittle_location').hide();
    return false;
  });
  
  $('.close_img_path').hide();
  $('.image_upload_path').mouseover(function(){
    $('.close_img_path').show();
  }).mouseout(function(){
    $('.close_img_path').hide();
  });
  
  $('.want_delete_popup').hide()
  $('.close_img_path').click(function(){
    $('.want_delete_popup').toggle();
    return false;
  });
  
  $('.cross').click(function(){
    $('.want_delete_popup').toggle();
    return false;
  });
  
  $('.upper_delete').click(function(){
    $('.want_delete_popup').toggle();
    return false;
  });
  
  $('.loc_style').mouseover(function(){
    $(this).find('.close_img_path').show();
  }).mouseout(function(){
    $('.close_img_path').hide();
  });
  
  $('.comment_down_arrow').hide();
  $('.people_comments').mouseover(function(){
    $(this).find('.comment_down_arrow').show();
  }).mouseout(function(){
    $('.comment_down_arrow').hide();
  });

  $('.timeline_user_bar_down').hide();
  $('.drag_user_bar').hide();
  $('.timeline_user_bar').mouseover(function(){
    $('.timeline_user_bar_down').show();
    $('.drag_user_bar').show();
    $('.down-sign').hide();
  }).mouseout(function(){
    $('.timeline_user_bar_down').hide();
    $('.drag_user_bar').hide();
    $('.down-sign').show();
  });
  
  $('.comment_down_arrow').click(function(){
    $(this).siblings('.action_menu_hide').toggle();
    $(this).toggleClass('comment_up_arrow');
    return false;
  })
  
  $('.thumbs_up').click(function(){
    $(this).addClass('thumbs_up_active');
    return false;
  });
  
  $('.thumbs_down').click(function(){
    $(this).addClass('thumbs_down_active');
    return false;
  });
  
  $('.body_text_hide').hide();
  $('.post-icon').click(function(){
    $('.post_timeline').hide('slow');
    $('.body_text_hide').show('slow');
    return false;
  });
  $('.body_text_hide').click(function(){
    $('.post_timeline').show('slow');
    $('.body_text_hide').hide();
    return false;
  });
  
  $('.attachments_hide').hide();
  $('.attach_icon').click(function(){
    $('.attach').hide('slow');
    $('.attachments_hide').show('slow');
    return false;
  });
  $('.attachments_hide').click(function(){
    $('.attach').show('slow');
    $('.attachments_hide').hide();
    return false;
  });
  
  $('.location_hide').hide();
  $('.post_location').click(function(){
    $('.own_jot').hide('slow');
    $('.location_hide').show('slow');
    return false;
  });
  $('.location_hide').click(function(){
    $('.own_jot').show('slow');
    $('.location_hide').hide();
    return false;
  });
  
  $('.tags_hide').hide();
  $('.own_tags_icon').click(function(){
    $('.tag-incognito').hide('slow');
    $('.tags_hide').show('slow');
    return false;
  });
  $('.tags_hide').click(function(){
    $('.tag-incognito').show('slow');
    $('.tags_hide').hide();
    return false;
  });
  
  $('.comments_hide').hide();
  $('.tag_incognito_icon').click(function(){
    $('.comment').hide('slow');
    $('.comment_pagiantion').hide('slow');
    $('.photo_reply_comment').hide('slow');
    $('.comments_hide').show('slow');
    return false;
  });
  $('.comments_hide').click(function(){
    $('.comment').show('slow');
    $('.comment_pagiantion').show('slow');
    $('.photo_reply_comment').show('slow');
    $('.comments_hide').hide();
    return false;
  });
  
  $('.update_close').hide();
  $('.notif_information').mouseover(function(){
    $(this).find('.update_close').show();
  }).mouseout(function(){
    $('.update_close').hide();
  });
  
  $('.pp_down_arrow').hide();
  $('.pp_link_tags').click(function(){
    $(this).addClass('pp_link_tab_active');
    $(this).siblings('.pp_down_arrow').show();
    $('.pp_link_jots').removeClass('pp_link_tab_active');
    $('.pp_link_jots').siblings('.pp_down_arrow').hide();
    $('.pp_link_follows').removeClass('pp_link_tab_active');
    $('.pp_link_follows').siblings('.pp_down_arrow').hide();
    return false
  });
  
  $('.pp_link_jots').click(function(){
    $(this).addClass('pp_link_tab_active');
    $(this).siblings('.pp_down_arrow').show();
    $('.pp_link_tags').removeClass('pp_link_tab_active');
    $('.pp_link_tags').siblings('.pp_down_arrow').hide();
    $('.pp_link_follows').removeClass('pp_link_tab_active');
    $('.pp_link_follows').siblings('.pp_down_arrow').hide();
    return false
  });
  
  $('.pp_link_follows').click(function(){
    $(this).addClass('pp_link_tab_active');
    $(this).siblings('.pp_down_arrow').show();
    $('.pp_link_tags').removeClass('pp_link_tab_active');
    $('.pp_link_tags').siblings('.pp_down_arrow').hide();
    $('.pp_link_jots').removeClass('pp_link_tab_active');
    $('.pp_link_jots').siblings('.pp_down_arrow').hide();
    return false
  });

  $('.upper_pannel').hide();
  $('.upper_pannel_hov').mouseover(function(){
    $('.upper_pannel').show();
    $(this).hide();
  });
  
  $('.pp_button_follows_icon').hide();
  $('.pp_button_follows').click(function(){
    $(this).toggleClass('pp_button_follows_active');
    $(this).find('.pp_button_follows_icon').toggle();
    return false
  });
  
  $('.pp_button_follows_icon').click(function(){
    $(this).siblings('.action_menu_hide').toggle();
    return false
  });
  
  $('.people_active').hide();
  $('.people_notactive').click(function(){
    $('.people_active').show();
    $('.search_notactive').show();
    $('.people_notactive').hide();
    $('.search_active').hide();
    return false
  });
  
  $('.search_active').hide();
  $('.search_notactive').click(function(){
    $('.search_active').show();
    $('.people_notactive').show();
    $('.search_notactive').hide();
    $('.people_active').hide();
    return false
  });
  
  $('.active_by_name').hide();
  $('.notactive_by_name').click(function(){
    $('.active_by_name').show();
    $('.notactive_by_kudos').show();
    $('.notactive_by_location').show();
    $('.notactive_by_tags').show();
    $('.notactive_by_name').hide();
    $('.active_by_kudos').hide();
    $('.active_by_location').hide();
    $('.active_by_tags').hide();
    return false
  });
  
  $('.active_by_kudos').hide();
  $('.notactive_by_kudos').click(function(){
    $('.active_by_kudos').show();
    $('.notactive_by_name').show();
    $('.notactive_by_location').show();
    $('.notactive_by_tags').show();
    $('.notactive_by_kudos').hide();
    $('.active_by_name').hide();
    $('.active_by_location').hide();
    $('.active_by_tags').hide();
    return false
  });
  
  $('.active_by_location').hide();
  $('.notactive_by_location').click(function(){
    $('.active_by_location').show();
    $('.notactive_by_name').show();
    $('.notactive_by_kudos').show();
    $('.notactive_by_tags').show();
    $('.notactive_by_location').hide();
    $('.active_by_kudos').hide();
    $('.active_by_name').hide();
    $('.active_by_tags').hide();
    return false
  });
  
  $('.active_by_tags').hide();
  $('.notactive_by_tags').click(function(){
    $('.active_by_tags').show();
    $('.notactive_by_location').show();
    $('.notactive_by_name').show();
    $('.notactive_by_kudos').show();
    
    $('.notactive_by_tags').hide();
    $('.active_by_kudos').hide();
    $('.active_by_name').hide();
    $('.active_by_location').hide();
    return false
  });
  
  $('.li_movies').mouseover(function(){
    $(this).find('.comment_down_arrow').show();
    $(this).find('.nest_magnifier_icon').show();
    $(this).find('.input_nest_static').addClass('input_nest_hover');
  }).mouseout(function(){
    $('.comment_down_arrow').hide();
    $('.nest_magnifier_icon').hide();
    $(this).find('.input_nest_static').removeClass('input_nest_hover');
  });
  
  $('.rename_popup').hide();
  $('.rename_idle').click(function(){
    $('.rename_popup').toggle();
    $(this).toggleClass('rename_click');
    return false
  });
  
  $('.delete_popup').hide();
  $('.delete').click(function(){
    $('.delete_popup').toggle();
    $(this).toggleClass('delete_click');
    return false
  });
  
  $('.search_box_nest').hide();
  $('.save_tags_popup').hide();
  $('.save_button_tags').click(function(){
    $('.save_tags_popup').toggle();
    $(this).toggleClass('save_button_tags_click');
    return false
  });
  
  $('.magnifier').click(function(){
    $('.search_box_nest').toggle();
    $(this).toggleClass('magnifier_click');
    return false
  });
  
  $('.under_cate_content').hide();
  $('.under_cate_top').click(function(){
    $('.under_cate_content').show();
    $('.under_cate_top').hide();
    return false
  });
  
  $('.under_dd_arrow_active').click(function(){
    $('.under_cate_content').hide();
    $('.under_cate_top').show();
    return false
  });
  
  $('.add_group_popup').hide();
  $('.add_group').click(function(){
    $('.add_group_popup').show();
    return false
  });
  
  $('.nest_empty_group').hide();
  $('.empty_nest_click').click(function(){
    $('.nest_empty_group').show();
    $('.add_group_popup').hide();
    $('.add_group').hide();
    return false
  });
});


$('#r-jot-tab').bind('click', function(){
  //jot
  $(this).find('.jot_text').addClass('jot_text_active');
  $('.jot-tab-content').show();
  $('#r-jot-result').show();
  $('#r-jot-result-detail').hide();
  
  //search
  $('#r-search-tab').find('.search_text').addClass('search_text_not_active');
  $('#r-search-tab').find('.img_1').addClass('img_1_not_active');
  $('.jot-search-content').hide();
  $('.welcome_content').hide();
  $('#r-people-search-result').hide();
  
  //login
  $('#signUp').removeClass('login');
  $('.login_content').hide();

  $('#r-signup-content').hide();


  //notifikasi
  $('#r-notif-mode-path').hide();
  $('#r-notification-tab').removeClass('r-notification-tab-active');

  //profile
  $('#r-profile-content').hide();
});

$('#signUp').bind('click', function(){
  //jot
  $('.jot-tab-content').hide();
  $('.jot_mode_hide').removeClass('show_more show_add show_upload show_tags').children().hide();
  $('.jot_buttons_path').find('a').removeClass('jot_click jot_click_active jot_buttons_active');
  $('#r-jot-tab').find('.jot_text').removeClass('jot_text_active');
  $('#r-jot-result').hide();
  $('#r-jot-result-detail').hide();

  //search
  $('#r-search-tab').find('.search_text').addClass('search_text_not_active');
  $('#r-search-tab').find('.img_1').addClass('img_1_not_active');
  $('.jot-search-content').hide();
  $('#r-people-search-result').hide();
  
  //login
  $('.login_content').show();
  $('#signUp').addClass('login');

  $('#r-signup-content').hide();
});

$('#r-search-tab').bind('click', function(){
  //jot
  $('.jot-tab-content').hide();
  $('.jot_mode_hide').removeClass('show_more show_add show_upload show_tags').children().hide();
  $('.jot_buttons_path').find('a').removeClass('jot_click jot_click_active jot_buttons_active');
  $('#r-jot-tab').find('.jot_text').removeClass('jot_text_active');
  $('#r-jot-result').hide();
  $('#r-jot-result-detail').hide();

  //login
  $('#signUp').removeClass('login');
  $('.login_content').hide();

  //search
  $('#r-search-tab').find('.search_text').removeClass('search_text_not_active');
  $('#r-search-tab').find('.img_1').removeClass('img_1_not_active');
  $('.jot-search-content').show();
  $('.welcome_content').show();
  $('#r-people-search-result').hide();

  $('#r-signup-content').hide();

  //notifikasi
  $('#r-notif-mode-path').hide();
  $('#r-notification-tab').removeClass('r-notification-tab-active');

  //profile
  $('#r-profile-content').hide();
});


$('#jot-search-field').bind('change', function(){
  var target =  $('#r-people-result-dropdwn');
  if(/[@]/.test(this.value)){
    target.show();
    $('.welcome_content').hide();
  }
  else{
    target.hide();
    $('.welcome_content').show();
  }
});

$('.r-people-result-dropdwn-item').bind('click', function(){
  $(this).parents('#r-people-result-dropdwn').hide();
  $('#r-people-search-result').show();
  $('.welcome_content').hide();
});

$('#r-jot-result').find('.link-to-detail-jot').bind('click', function(){
  $('#r-jot-result-detail').show();
  $('#r-jot-result').hide();
  return false;
});

$('#r-notification-tab').bind('click', function(){
  $(this).addClass('r-notification-tab-active');
  $('#r-notif-mode-path').show();

  //jot
  $('.jot-tab-content').hide();
  $('.jot_mode_hide').removeClass('show_more show_add show_upload show_tags').children().hide();
  $('.jot_buttons_path').find('a').removeClass('jot_click jot_click_active jot_buttons_active');
  $('#r-jot-tab').find('.jot_text').removeClass('jot_text_active');
  $('#r-jot-result').hide();
  $('#r-jot-result-detail').hide();

  //search
  $('#r-search-tab').find('.search_text').addClass('search_text_not_active');
  $('#r-search-tab').find('.img_1').addClass('img_1_not_active');
  $('.jot-search-content').hide();
  $('#r-people-search-result').hide();

  //profile
  $('#r-profile-content').hide();
  $('#r-welcome-content').hide();
});

$('#user_logged').bind('click', function(){
  //notifikasi
  $('#r-notif-mode-path').hide();
  $('#r-notification-tab').removeClass('r-notification-tab-active');
  
  //jot
  $('.jot-tab-content').hide();
  $('.jot_mode_hide').removeClass('show_more show_add show_upload show_tags').children().hide();
  $('.jot_buttons_path').find('a').removeClass('jot_click jot_click_active jot_buttons_active');
  $('#r-jot-tab').find('.jot_text').removeClass('jot_text_active');
  $('#r-jot-result').hide();
  $('#r-jot-result-detail').hide();

  //search
  $('#r-search-tab').find('.search_text').addClass('search_text_not_active');
  $('#r-search-tab').find('.img_1').addClass('img_1_not_active');
  $('.jot-search-content').hide();
  $('#r-people-search-result').hide();
});