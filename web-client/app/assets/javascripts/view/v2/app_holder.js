window.AppHolderView = AppView.extend({
  template: _.template($('#holder-template').html()),

  template_variables: {
    className: '',
    idName: ''
  }
});