window.JotAddClip = AppView.extend({

  initialize: function(options){
  },

  render: function(){
  },

  events: {
    'keydown': 'findLocation'
  },

  location_index: 0,

  findLocation: function(event){

    if(event.keyCode == 13){
      $('<div class="clearfix"><input type="text" name="jot[locations_attributes]['+ this.location_index +'][name]" value="'+ this.el.value +'"></div>').appendTo('#main-magicbox-jot-input-clip-uploaded-files');
      this.el.value = '';
      this.location_index++;
    }
  }
});