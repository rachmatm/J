$('.colorbox-close').live('click', function(e){
  e.preventDefault();
  $.colorbox.close();
});

$("textarea.autogrow").live('focus', function(e){
  if(!$(this).is('.autogrow-active')){
    $(this).autoGrow().addClass('autogrow-active');
  }
})