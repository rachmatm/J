window.CurrentUserTwoModel = Backbone.Model.extend({

  initialize: function(){
    this.getData();
  },

  setData: function(data, token, attributes, auth){
    localStorage.jotky_current_user = JSON.stringify(data);

    if(attributes){
      localStorage.jotky_current_attributes = JSON.stringify(attributes);
    }

    if(auth){
      localStorage.jotky_current_auth = auth;
    }

    if(token){
      localStorage.jotky_current_token = token;

      $.cookie("jotky_token", token, {
        expires : 10,
        path    : '/',
        domain  : window.location.hostname,
        secure  : false
      });
    }

    this.getData();
  },

  unsetData: function(){
    localStorage.removeItem('jotky_current_user');
    localStorage.removeItem('jotky_current_token');
    localStorage.removeItem('jotky_current_attributes');
    localStorage.removeItem('jotky_current_auth');

    $.cookie("jotky_token", null)
    $.cookie("jotky_token", null, {
      path    : '/',
      domain  : window.location.hostname,
      secure  : false,
      raw: true
    });

    this.getData();
  },

  getData: function(){
    var data = JSON.parse(localStorage.jotky_current_user || '{}');
    var token = localStorage.jotky_current_token;
    var attributes = JSON.parse(localStorage.jotky_current_attributes || '{}');
    var auth = localStorage.jotky_current_auth;

    return window.CURRENT_USER = {
      data: data,
      token: token,
      attributes: attributes,
      auth: auth
    };
  }
})