window.MagicboxSearchView = Backbone.View.extend({
  
  default_options: {
    elNav: '',
    el: ''
  },

  initialize: function(options){
    var _this = this;
    
    this.options = $.extend({}, this.default_options, options);

    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');

    $('#magic-box-search-form').validate({
      rules: {
        'jot[title]': {
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
            else if(data.content.users){
              _this.middleView.openSearchResult(data.content);
            }
            else if(data.content.jots){
              _this.middleView. openSearchResultJot(data.content);
            }
          }
        });

        return false;
      }
    });
  },

  open: function(){
    $(this.options.elNav).find('.img_1').removeClass('img_1_not_active');
    $(this.options.elNav).find('.search_text').removeClass('search_text_not_active');
    $(this.options.el).removeClass('hidden');
  },

  close: function(){
    $(this.options.elNav).find('.img_1').addClass('img_1_not_active');
    $(this.options.elNav).find('.search_text').addClass('search_text_not_active');
  }
})