function replaceMentionsWithHtmlLinks(text, mentions) {
  var mentioned_names = text.match(/@(\w+)/gi);
  var modified_text = text;

  _.each(mentioned_names, function(data) {
    var regexp = RegExp.new(data, 'gi');

    if (in_array(data, _.pluck(mentions, 'name'))) {
      modified_text = modified_text.replace(regexp, '<a href="#!/users/');
    }

  });
}
