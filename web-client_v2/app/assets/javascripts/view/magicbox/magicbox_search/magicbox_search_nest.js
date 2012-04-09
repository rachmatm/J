window.MagicboxSearchNestView = MagicboxSearchView.extend({

  template: _.template($('#search-result-nest-template').html()),
  
  initialize: function(){
    this.elContent = $('#magicbox-search');
    this.elNav = $('#magicbox-navigation-search');

    this.searches = new SearchCollection;
    this.searches.bind('reset', this.reset, this);
    this.validates();

    this.data = this.model.toJSON();
  },

  validates: function(){ 
    var _this = this;
    
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
    var _this = this;

    $(this.elNav).find('.img_1').removeClass('img_1_not_active');
    $(this.elNav).find('.search_text').removeClass('search_text_not_active');
    $(this.elContent).removeClass('hidden');

    this.validates();

    $('#search-result-nest-holder').html(this.template( this.data ));
    $('#magicbox-search-options').removeClass('hidden');

    this.saveSearchFormEl = $('#search-result-nest-form');

    $(this.saveSearchFormEl).validate({

      submitHandler: function(form){
        $(form).ajaxSubmit({});
      }
    });

    $('.link-to-save-search-tags').bind('click', function(){
      var search_result_caption= [];
      $(_this.saveSearchFormEl).find('.field-to-add:checked').each(function(){
        search_result_caption.push(this.value);
      });
      
      $('#search-result-nest-caption').html(search_result_caption.join(' &gt; '));
      $.colorbox({href: '#search-result-nest-save-popup', inline:true, escKey: false});
    });

    $('#search-result-nest-submit').bind('click', function(){
      $('#nest-item-field-2').val($('#nest-item-field-1').val());
      $(_this.saveSearchFormEl).trigger('submit');
    })
  },

  close: function(){
    $('#magicbox-search-options').removeClass('hidden');
  },

  reset: function(){
    var _this = this;

    var collections = this.searches.toJSON();
    var data = this.resetDeep(collections, 0)

    var list_holder = $('#list-search-result-tags');

    list_holder.html('');

    $.each(data, function(level, data){
      _this.holderView = new HolderView;
      _this.holderView.setElement(list_holder);

      _this.holderView.render({
        id: 'list-tags-' + level,
        className: 'list-tags clearfix'
      }, false, 'ul');

      $.each(data, function(index, item){
        _this.listView = new ListView({
          model: item
        });

        _this.listView.setElement(_this.holderView.holder_el)
        _this.listView.openListTag();
      })
      
    })
  },

  resetDeep: function(collections, index, data){
    var data = data || [];
    var _this = this;
    
    $.each(collections, function(ci, cv){

      if(ci == 5){
        return false;
      }

      data[index] = data[index] || [];
      data[index].push({
        tag: cv.tag_id
      });

      if(cv.child_tmp_search_tag_results){
       
        data = _this.resetDeep(cv.child_tmp_search_tag_results, index + 1, data);
      }
    });
    
    return data;
  }
});