window.HolderView = Backbone.View.extend({

  holder_el: '',

  default_variables: {
    'id': 'holder-' + Date.now(),
    'className': 'holder-view'
  },

  render: function(variables, reverse){

    this.default_variables = $.extend({}, this.default_variables, variables);

    if(reverse){
      this.holder_el = $('<div id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></div>').prependTo(this.el);
    }
    else{
      this.holder_el = $('<div id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></div>').appendTo(this.el);
    }

    return this;
  }
})