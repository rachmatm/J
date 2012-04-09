window.ListMessagesView = Backbone.View.extend({

  template: _.template($('#list-messages-template').html()),

  initialize: function(){
    this.currentUserModel = new CurrentUserModel;
    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');
    this.messageReplies = new MessageRepliesCollection({id: this.model.toJSON()._id});
    this.messageReplies.reset();
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
    var _this = this;

    this.data = $.extend( this.model.toJSON(), {
      current_user: this.currentUserModel.data()
    });

    $(this.$el).html(this.template( this.data ));

    this.messageReplies.fetch();

    this.resetItem();

    this.validates(this.el);

    $("abbr.timeago").timeago();

    $('.reply_message_path').hide();

    $('.action_menu_hide').hide();

    $(this.el).find('.replay_button').click(function(){
      $($(this).parent()).trigger('submit');
    });
  },

  validates: function(formEl){
    var _this = this;

    $(formEl).find('#message-reply-form').validate({
      rules: {
      },

      errorPlacement: function(){},

      submitHandler: function(form){

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              alert(data.error);
            }
            else{
              $(_this.el).find('.textarea-form-reply').val('');
              $(_this.el).find('.message_path > .messages_middle_path > span').removeClass('read_message');
              $(_this.el).find('.message_path > .messages_middle_path > span').addClass('new_message');
              _this.messageReplies.fetch();
            }
          }
        });

        return false;
      }
    });
  },

  expand_message: function(){
    $(this.el).find('.reply_message_path').toggle();
    return false;
  },

  action_menu_show: function(){
    $(this.el).find('.messages_down_arrow').siblings('.action_menu_hide').toggle();
    $(this.el).find('.messages_down_arrow').toggleClass('messages_up_arrow');
    return false;
  },

  reply: function(e){
    $(this.el).find('.reply_message_path').show();

    $(this.el).find('.action_menu_hide').hide();

    $(this.el).find('.textarea-form-reply').focus();
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
        $(_this.el).find('.message_path > .messages_middle_path > span').removeClass('new_message');
        $(_this.el).find('.message_path > .messages_middle_path > span').addClass('read_message');
      }
    });
  },

  addItem: function(data){
    this.item(data, true)
  },

  renderItem: function(){
    
  },

  resetItem: function(){
    var _this = this;

    $(_this.el).find('#reply-message-list-' + _this.data._id).html('');
    $(_this.el).find('a.count_read_message_new > span').html(_this.messageReplies.length);
    this.messageReplies.each(function(reply_data){
      _this.resetItem();
    });
  },

  item: function(data, reverse){
    var _this = this;

    this.listView = new ListView({
      model: data
    });

    this.listView.setElement('#reply-message-list-' + _this.data._id);
    this.listView.openMessageReplies(reverse);
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
