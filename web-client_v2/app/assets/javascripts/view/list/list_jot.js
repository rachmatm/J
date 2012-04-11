window.ListJotView = Backbone.View.extend({
  
  template: _.template($('#list-jot-template').html()),

  initialize: function(){
    this.currentUserModel = new CurrentUserModel;
    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');
    this.sidebarView = new SidebarView;
  },

  events: {
    'click .link-to-thumbsup': 'thumbsup',
    'click .link-to-thumbsdown': 'thumbsdown',
    'click .link-to-fav': 'favorite',
    'click .link-to-destroy': 'destroy',
    'click .link-to-show-comment-all': 'showCommentAll'
  },

  data: {},

  render: function(){
    this.data = $.extend( this.model.toJSON(), {
      current_user: this.currentUserModel.data()
    });

    log(this.data)

    this.comments = new CommentCollection(this.data._id);
    this.comments.bind('add', this.addComment, this);
    this.comments.bind('all', this.renderComment, this);
    this.comments.bind('reset', this.resetComment, this);

    $(this.el).html(this.template( this.data ));
    $("abbr.timeago").timeago();

    this.commentValidates();
    this.comments.more({
      timestamp: 'now'
    });
  },

  thumbsup: function(){
    var _this = this;
    
    $.ajax({
      url: '/jots/'+ this.data._id + '/thumbsup.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        _this.success.call(_this, data, textStatus, jqXHR)
      }
    });
  },

  thumbsdown: function(){
    var _this = this;

    $.ajax({
      url: '/jots/'+ this.data._id + '/thumbsdown.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        _this.success.call(_this, data, textStatus, jqXHR)
      }
    });
  },

  favorite: function(){
    var _this = this;
    
    $.ajax({
      url: '/jots/'+ this.data._id + '/favorite.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        console.log( _this.sidebarView.sidebarFavorites.fetch() );
        _this.success.call(_this, data, textStatus, jqXHR);
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
      this.sidebarView.sidebarFavorites.fetch();
      this.model.set(data.content);
      this.render();
    }
  },

  destroy: function(){
    var _this = this;

    $.ajax({
      url: "/jots/" + this.data._id + '/destroy.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
        else{
          _this.remove();
        }
      }
    });
  },

  addComment: function(data){
    this.comment(data, true);
  },

  renderComment: function(){
    $('#jot-'+ this.data._id +'-comment-counter').text(this.comments.query.total);
  },

  resetComment: function(){
    var _this = this;

    if(this.listView && this.listView.el){
      $(this.listView.el).children().remove();
    }
    
    this.comments.each(function(data){
      _this.comment(data);
    });
  },

  comment: function(data, reverse){
    this.listView = new ListView({
      model: data
    });
    this.listView.setElement('#list-comment-holder-'+ this.data._id)
    this.listView.openComment(reverse);
  },

  comment_validates_passed: 1,

  commentValidates: function(){
    this.commentFormEl = $('#jot-comment-form-' + this.data._id);

    var _this = this;

    $(this.commentFormEl).validate({
      rules: {
        'comment[message]': {
          required: true
        }
      },
      errorPlacement: function(){},

      submitHandler: function(form){
        if(!_this.comment_validates_passed){
          return false;
        }

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR){
            
            if(data.failed === true){
              alert(data.error);
            }
            else{
              _this.comments.addWithQuery(data.content, data.query);
            }

            $(form).find('input').removeAttr('disabled');
            $(form).resetForm();
            _this.comment_validates_passed = 1;
          },
          beforeSend: function(jqXHR, settings){
            $(form).find('input').attr({
              disabled: 'disabled'
            });

            _this.comment_validates_passed = null;
          }
        });

        return false;
      }
    });

    $('#jot-comment-form-' + this.data._id + '-submit').bind('click', function(){
      $(_this.commentFormEl).trigger('submit');
    }); 
  },

  show_comment_all_active: null,

  showCommentAll: function(){
    if(this.show_comment_all_active){
      $('.link-to-show-comment-all').text('View all')
      this.comments.more({
        timestamp: 'now'
      });
      this.show_comment_all_active = null;
    }
    else{
      $('.link-to-show-comment-all').text('View top 5')
      this.comments.fetch();
      this.show_comment_all_active = 1;
    }
  }
});
