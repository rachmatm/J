window.JotItemView = Backbone.View.extend({

  template:  _.template($('#main-listing-jot-item-template').html()),

  default_variables: {
    jot_user_username: '',
    jot_user_user_thumbs_down_ids: [],
    jot_user_user_thumbs_up_ids: [],
    jot_title: '',
    jot_created_at:'',
    jot_detail: ''
  },

  render: function(variables){

    var _variables = $.extend({}, this.default_variables, variables);

    $(this.el).html(this.template(_variables));
  }
});