window.CurrentUserModel = Backbone.Model.extend({

  initialize: function(){
    
  },

  setAuth: function(){
    var _this = this;

    $(window).bind('jotky_login', function(event, token){
      _this.setProfileAndLogin(token);
    });

    $(window).bind('jotky_logout', function(event, token){
      _this.unsetData();
      _this.unsetToken();

      _this.after_logout.call(_this, _this.data(), _this.token());
    });
  },

  data: function(){
    return JSON.parse(localStorage.jotky_user_session);
  } ,

  token: function(){
    return $.cookie("jotky_token")
  },

  setData: function(data){
    localStorage.jotky_user_session = JSON.stringify(data);
  },

  setToken: function(token){
    $.cookie("jotky_token", token, {
      expires : 10,
      path    : '/',
      domain  : DOMAIN,
      secure  : false
    });
  },

  unsetData: function(){
    localStorage.jotky_user_session = "{}";
  },

  unsetToken: function(){
    $.cookie("jotky_token", null);
  },

  setProfileAndLogin: function(token){
    var _this = this;
    
    $.ajax({
      url: '/profiles.json',
      data: {
        token: token
      },
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error)
        }
        else{
          _this.setData(data.content);
          _this.setToken(token);

          _this.after_login.call(_this, _this.data(), _this.token());
        }
      }
    });
  },

  after_login: function(){},

  after_logout: function(){}
});