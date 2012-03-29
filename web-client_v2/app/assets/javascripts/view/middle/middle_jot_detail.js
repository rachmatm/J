window.MiddleJotDetailView = Backbone.View.extend({

  template: _.template($('#jot-detail-template').html()),

  initialize: function(){
  },

  render: function(data){
    $(this.el).html(this.template(data));
    
    this.comments = new CommentCollection(data._id);
    this.comments.bind('add', this.addComment, this);
    this.comments.bind('all', this.renderComment, this);
    this.comments.bind('reset', this.resetComment, this);
    this.comments.fetch();

    this.validates();
  },

  validates: function(){
    var _this = this;

    this.commentFormEl = $('#jot-comment-form');

    $(this.commentFormEl).validate({
      rules: {
        'comment[message]': {
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
              _this.comments.add(data.content);
            }
          }
        });

        return false;
      }
    });

    $(this.commentFormEl).bind('click', function(){
      $(_this.commentFormEl).trigger('submit');
    });
  },

  addComment: function(data){
    this.comment(data)
  },

  renderComment: function(){
    
  },

  resetComment: function(){
    var _this = this;
    this.comments.each(function(data){
      _this.comment(data);
    });
  },

  comment: function(data, reverse){
    this.listView = new ListView({
      model: data
    });
    this.listView.setElement('#jot-detail-comment-list');
    this.listView.openComment(reverse);
  }
})