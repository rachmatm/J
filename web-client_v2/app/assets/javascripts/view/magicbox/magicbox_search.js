window.MagicboxSearchView = Backbone.View.extend({

  initialize: function(){
    this.elContent = $('#magicbox-search');
    this.elNav = $('#magicbox-navigation-search');

    this.searches = new SearchCollection;
    this.searches.bind('reset', this.reset, this);

    this.validates();
  },

  validates: function(){
    var _this = this;
    var type = 'normal';

    $('#magic-box-search-form').validate({
      rules: {
        'keyword': {
          required: true
        }
      },

      errorPlacement: function(){},

      submitHandler: function(form){
        _this.searches.fetch_by_type('nest', {
          keyword: $('#magic-box-search-field').val()
        });

        return false;
      }
    });
  },

  open: function(){
    $(this.elNav).find('.img_1').removeClass('img_1_not_active');
    $(this.elNav).find('.search_text').removeClass('search_text_not_active');
    $(this.elContent).removeClass('hidden');
  },

  close: function(){
    $(this.elNav).find('.img_1').addClass('img_1_not_active');
    $(this.elNav).find('.search_text').addClass('search_text_not_active');
  },

  reset: function(){
  },

  renderItem: function(data, reverse){
  }
});
