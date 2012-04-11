window.ListJotTagView = Backbone.View.extend({
  template: _.template($('#list-jot-tag-template').html()),

  render: function(){
    this.data = this.model;

    $(this.el).html(this.template(this.data));
  },

  events: {
    'click .jot_middle_tags_active': 'remove_tag'
  },

  remove_tag: function(){
    var tag_remove_regex = new RegExp('(.*)#' + this.data.name + '(.*)', 'gi');
    var new_string = $('#jot-form-title-field').val().replace(tag_remove_regex, '$1$2');

    $('#jot-form-title-field').val(new_string);
    this.remove();
  }

})
