window.MiddleMessagesView = Backbone.View.extend({

  template: _.template($('#messages-template').html()),

  initialize: function(){
    this.messages = new MessageCollection;
    this.messages.bind('add', this.addItem, this);
    this.messages.bind('all', this.renderItem, this);
    this.messages.bind('reset', this.resetItem, this);
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template());

    this.messages.fetch();

    this.validates();

    this.sort_by_date();
    this.sort_by_name();

    $('.compose_message_form').hide();
    $('.compose_new_message').toggle(function(){
      $(this).addClass('compose_new_message_active');
      $('.compose_message_form').show();
    }, function(){
      $(this).removeClass('compose_new_message_active');
      $('.compose_message_form').hide();
    });
  },

  events: {
  },

  sort_by_date: function(){
    var _this = this;

    $('.link-to-sort-by-date').toggle(function(){
      _this.messages.fetch({success: function(collection, response) {
        _this.messages = new MessageCollection(_.sortBy(response.content, function(message_data){
          return message_data.updated_at;
        }).reverse());
        _this.resetItem();
      }});
    }, function(){
      _this.messages.fetch({success: function(collection, response) {
        _this.messages = new MessageCollection(_.sortBy(response.content, function(message_data){
          return message_data.updated_at;
        }));
        _this.resetItem();
      }});
    });
  },

  sort_by_name: function(){
    var _this = this;

    $('.link-to-sort-by-name').toggle(function(){
      _this.messages.fetch({success: function(collection, response) {
        _this.messages = new MessageCollection(_.sortBy(response.content, function(message_data){
          return message_data.from;
        }).reverse());
        _this.resetItem();
      }});
    }, function(){
      _this.messages.fetch({success: function(collection, response) {
        _this.messages = new MessageCollection(_.sortBy(response.content, function(message_data){
          return message_data.from;
        }));
        _this.resetItem();
      }});
    });
  },

  addItem: function(data){
    this.item(data, true);
  },

  renderItem: function(){
    
  },

  resetItem: function(){
    var _this = this;

    $('#main-middle-messages-list').empty();
    this.messages.each(function(data){
      _this.item(data);
    });
  },

  item: function(data, reverse){

    this.listView = new ListView({
      model: data
    });

    this.listView.setElement('#main-middle-messages-list');
    this.listView.openMessages(reverse);
  },

  validates: function(){
    var _this = this;

    $('#message-form').validate({
      rules: {
        'message[receiver]': {
          required: true
        }
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
              _this.messages.fetch();
              _this.resetItem();
              $('#message-form .to_form, #message-form .subject_form, .compose_message_form textarea').val('')
              $('.compose_new_message').trigger('click');
            }
          }
        });

        return false;
      }
    });
  }
});
