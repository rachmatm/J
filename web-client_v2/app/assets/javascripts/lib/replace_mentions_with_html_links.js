function replaceMentionsWithHtmlLinks(text, mentions) {
  var mentioned_names = text.match(/@(\w+)/gi);
  var modified_text = text;

  _.each(mentioned_names, function(data) {
    var regexp = new RegExp(data + '\\b', 'gi');
    var sliced_name = data.slice(1, data.length);

    if (in_array(sliced_name, _.pluck(mentions, 'username'))) {
      var user = _.find(mentions, function(hash) {
        return hash.username == sliced_name;
      });
      modified_text = modified_text.replace(regexp, '<a href="#!/users/' + user.user_id + '">' + data + '</a>' );
    }

  });

  return modified_text;
}
