window.ListMessagesView = Backbone.View.extend({

  template: _.template($('#list-messages-template').html()),

  initialize: function(){
    this.currentUserModel = new CurrentUserModel;
    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');
    this.messageReplies = new MessageRepliesCollection();
    this.messageReplies.bind('add', this.addItem, this);
    this.messageReplies.bind('all', this.renderItem, this);
    this.messageReplies.bind('reset', this.resetItem, this);
  },

  events: {
    'click .message_path': 'expand_message',
    'click .messages_down_arrow': 'action_menu_show',
    'click .reply_hide': 'reply',
    'click .delete_hide': 'delete',
    'click .mark_read_hide': 'mark_read'
  },

  data: {},

  render: function(){
    this.data = $.extend( this.model.toJSON(), {
      current_user: this.currentUserModel.data()
    });

    $(this.$el).html(this.template( this.data ));

    console.log(this.messageReplies.url);
    this.validates();

    $("abbr.timeago").timeago();

    $('.reply_message_path').hide();

    $('.action_menu_hide').hide();

    $(this.el).find('.replay_button').click(function(){
      $($(this).parent()).trigger('submit');
    });
  },

  validates: function(){
    $('.message-reply-form').validate({
      rules: {
      },

      errorPlacement: function(){},

      submitHandler: function(form){
        
        $(form).ajaxSubmit({
          type: 'post',
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              alert(data.error);
            }
            else{
            }
          }
        });

        return false;
      }
    });
  },

  expand_message: function(){
    $('.message_path').click(function(){
      $(this).siblings('.reply_message_path').toggle();
      return false;
    });
  },

  action_menu_show: function(){
    $(this.el).find('.messages_down_arrow').siblings('.action_menu_hide').toggle();
    $(this.el).find('.messages_down_arrow').toggleClass('messages_up_arrow');
    return false;
  },

  reply: function(e){
    var _this = this;
    console.log(this);
  },

  delete: function(e){
    var _this = this;

    $.ajax({
      url: "/messages/" + this.data._id + '/destroy.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        $(_this.el).remove();
      }
    });
  },

  mark_read: function(e){
    var _this = this;

    $.ajax({
      url: '/messages/'+ this.data._id + '/mark_read.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        _this.success.call(_this, data, textStatus, jqXHR)
      }
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
