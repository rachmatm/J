window.ListJotView = Backbone.View.extend({
  
  template: _.template($('#list-jot-template').html()),

  initialize: function(){
    this.currentUserModel = new CurrentUserModel;
    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');
    this.sidebarView = new SidebarView;

    this.data = $.extend( this.model.toJSON(), {
      current_user: this.currentUserModel.data()
    });

    this.comments = new CommentCollection(this.data._id);
    this.comments.bind('add', this.addComment, this);
    this.comments.bind('all', this.renderComment, this);
    this.comments.bind('reset', this.resetComment, this);
    
  },

  events: {
    'click .link-to-thumbsup': 'thumbsup',
    'click .link-to-thumbsdown': 'thumbsdown',
    'click .link-to-fav': 'favorite',
    'click .link-to-detail': 'detail'
  },

  data: {},

  render: function(){
    $(this.el).html(this.template( this.data ));
    $("abbr.timeago").timeago();

    this.commentValidates();
    this.comments.fetch();
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

  detail: function(){
    this.middleView.openJotDetail(this.data)
  },

  addComment: function(data){
    this.comment(data, true)
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
    this.listView.setElement('#list-comment-holder-'+ this.data._id)
    this.listView.openComment(reverse);
  },

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

    $('#jot-comment-form-' + this.data._id + '-submit').bind('click', function(){
      $(_this.commentFormEl).trigger('submit');
    }); 
  }
});
