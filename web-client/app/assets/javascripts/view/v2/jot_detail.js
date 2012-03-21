window.JotDetailView = AppView.extend({

  el: $('#jot-detail'),
  
  elForm: $('#jot-comment-form'),
  
  elList: $('#jot-detail-comment'),
  
  elListHolder: $('#scrollbar1'),

  elListPagination: $('#jot-detail-comment-pagiantion'),

  events: {
    'click #jot-comment-form-submit': 'submitTheForm',
    'click #jot-detail-comment-next': 'nextCommentPage',
    'click #jot-detail-comment-prev': 'prevCommentPage'
  },

  getting_submited: false,

  current_comment_page_index: 1,

  initialize: function(jot_id){
    var _this = this;
    this.jot_id = jot_id;

    this.jotCommentCollection = new JotCommentCollection(jot_id);
    this.jotCommentView = new JotCommentView;

    $(this.elForm).validate({
      rules: {
        'comment[detail]': {
          required: true
        }
      },
      errorPlacement: function(error, element){},

      submitHandler: function(form){
        
        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
            _this.enableForm();
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              alert(data.error);
            }
            else{
              _this.jotCommentCollection.add(data.content);
            }

            _this.enableForm();
          },

          beforeSend: function(){
            _this.disableForm();
          }
        });
      }
    });

    this.jotCommentCollection.bind('add', this.addOne, this);
    this.jotCommentCollection.bind('reset', this.addAllItem, this);
    this.jotCommentCollection.bind('all', this.render, this);


    this.get(this.current_comment_page_index);
  },

  get: function(page){
    this.jotCommentCollection.fetch({
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }

      },
      data: {
        per_page: 5,
        page: page
      }
    });
  },

  render: function(){
    var query_data = this.jotCommentCollection.query;
    this.comment_total_page = query_data.total_page;
    this.comment_total = query_data.total_comment;
    this.comment_per_page = query_data.per_page;
    this.comment_page = query_data.page;

    this.setPagination();
    

    this.elListHolder.tinyscrollbar();
    this.elListHolder.tinyscrollbar_update('bottom');

    var content_holder = this.elListHolder.find('.overview');
  },

  setPagination: function(){
    var _this = this;

    this.elListPagination.html('');
    
    _(this.comment_total_page).times(function(){
      _this.elListPagination.append('<li class="nonActivePage_comments"></li>');
    });

    this.elListPagination.children('li').eq(this.comment_page - 1).addClass('activePage_comments').removeClass('nonActivePage_comments');
    
  },

  addAllItem: function(){
    var _this = this;

    this.jotCommentCollection.each(function(data){
      _this.addOne(data);
    });
  },

  addOne: function(data, reverse){
    var obj_data = data.toJSON();

    this.jotCommentView.setElement(this.createCommentHolder(obj_data._id))
    this.jotCommentView.render(obj_data);
  },

  createCommentHolder: function(id, reverse){
    if(reverse){
      return $("<li id='jot-comment-item-"+ id +"'></li>").prependTo(this.elList);
    }
    else{
      return $("<li id='jot-comment-item-"+ id +"'></li>").appendTo(this.elList);
    }
  },

  submitTheForm: function(){
    this.elForm.submit();
    return false;
  },

  disableForm: function(){
    $(this.elForm).find('input, textarea').attr({
      'disabled': 'disabled'
    });

    this.getting_submited = true;
  },

  enableForm: function(){
    $(this.elForm).find('input, textarea').removeAttr('disabled');
    this.getting_submited = false;
  },

  nextCommentPage: function(){
    if(this.current_comment_page_index < this.comment_total_page){
      this.current_comment_page_index++;
      this.get(this.current_comment_page_index);
    }
    
    return false;
  },

  prevCommentPage: function(){
    if(this.current_comment_page_index > 1){
      this.current_comment_page_index--;
      this.get(this.current_comment_page_index);
    }
    
    return false;
  }
});