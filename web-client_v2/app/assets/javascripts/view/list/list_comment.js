window.ListCommentView = Backbone.View.extend({
  template: _.template($('#list-comment-template').html()),

  render: function(){
    this.data = this.model.toJSON();
    
    $(this.el).html(this.template(this.data));

    $("abbr.timeago").timeago();
  }
})