window.ListTagView = Backbone.View.extend({
  template: _.template($('#list-tag-template').html()),

  render: function(){
    this.data = this.model;

    $(this.el).html(this.template(this.data));
  },

  events: {
    'click .link-to-add-to-nest': 'addItemNest',
    'click .link-to-add-to-reset': 'reset'

  },

  addItemNest: function(){

    var item = $('#list-tag-'+ this.data.tag);
    var item_field = item.find('.field-to-add');
    var item_text = item.find('.choice_text');
    var item_icon = item.find('.not_active');

    if(item_field.is(':checked')){
      item_field.removeAttr('checked');
      item_text.removeClass('active_choiceText');
      item_icon.removeClass('icon_notActive');
    }
    else{
      item_field.attr({
        checked: 'checked'
      });
      item_text.addClass('active_choiceText');
      item_icon.addClass('icon_notActive');
    }

    
    
  },

  reset: function(){
    $('#magic-box-search-field').val(this.data.tag).parents('form').trigger('submit');
  }
})