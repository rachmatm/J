window.JotItem = AppView.extend({
  template: _.template($('#main-listing-jot-item-template').html()),

  template_variables: {title: '', detail: ''}
});