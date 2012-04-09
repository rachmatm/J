window.HolderView = Backbone.View.extend({

  holder_el: '',

  default_variables: {
    'id': 'holder-' + Date.now(),
    'className': 'holder-view'
  },

  render: function(variables, reverse, type){

    this.default_variables = $.extend({}, this.default_variables, variables);

    if(type == 'ul' && reverse){
      this.holder_el = $('<ul id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></ul>').prependTo(this.el);
    }
    else if(type == 'ul'){
     this.holder_el = $('<ul id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></ul>').appendTo(this.el);
    }
    else if(type == 'li' && reverse){
      this.holder_el = $('<li id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></li>').prependTo(this.el);
    }
    else if(type == 'li'){
     this.holder_el = $('<li id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></li>').appendTo(this.el);
    }
    else if(type == 'tr' && reverse){
      this.holder_el = $('<tr id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></tr>').prependTo(this.el);
    }
    else if(type == 'tr'){
     this.holder_el = $('<tr id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></tr>').appendTo(this.el);
    }
    else if(reverse){
      this.holder_el = $('<div id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></div>').prependTo(this.el);
    }
    else{
      this.holder_el = $('<div id="'+ this.default_variables.id +'" class="'+ this.default_variables.className +'"></div>').appendTo(this.el);
    }

    return this;
  }
})