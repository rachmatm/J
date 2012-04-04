window.ListMessageRepliesView = Backbone.View.extend({

  template: _.template($('#list-message-replies-template').html()),

  initialize: function(){
    this.currentUserModel = new CurrentUserModel;
    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');
  },

  events: {
    'click .message_path': 'expand_message'
  },

  data: {},

  render: function(){
    this.data = $.extend( this.model.toJSON(), {
      current_user: this.currentUserModel.data()
    });

    $(this.$el).html(this.template( this.data ));

    this.validates();

    $("abbr.timeago").timeago();

    $('.reply_message_path').hide();

    $('.action_menu_hide').hide();

    $(this.el).find('.replay_button').click(function(){
      $($(this).parent()).trigger('submit');
    });
  },

  error: function(jqXHR, textStatus, errorThrown){
    alert(textStatus);
  },

  success: function(data, textStatus, jqXHR){
    if(data.failed === true){
      alert(data.error);
    }
    else{
      this.model.set(data.content);
      this.render();
    }
  }
});
