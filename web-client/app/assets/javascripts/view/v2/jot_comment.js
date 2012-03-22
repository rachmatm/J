window.JotCommentView = AppView.extend({
  template: _.template($('#main-listing-jot-comment-item-template').html()),

  template_variables: {
    username: '',
    created_at: '',
    detail: ''
  }
});