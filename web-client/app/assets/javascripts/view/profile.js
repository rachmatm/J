window.ProfileView = Backbone.View.extend({

  template: _.template($('#main-magicbox-profile-template').html()),

  initialize: function(){
    this.editNicknameRealnameView = new EditNicknameRealnameView;
    this.editBioView = new EditBioView;
    this.editUrlView = new EditUrlView;
    this.editLocationView = new EditLocationView;
    this.holderView = new HolderView;
    this.formView = new FormView;
    this.alertView = new AlertView;

    this.render();
  },

  events: {
    "click .nickname_realname": "open_nickname_realname_form",
    "click .empty_bio_text": "open_bio_form",
    "click .empty_url_text": "open_url_form",
    "click .empty_location_text": "open_location_form"
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template);
  },

  open_nickname_realname_form: function(){
    
  },

  close_nickname_realname_form: function(){
    
  },

  open_bio_form: function(){
    
  },

  close_bio_form: function(){
    
  },

  open_url_form: function(){
    alert('test');
    console.log(this)
    this.editUrlView.render();
    $('.empty_url_field').hide();
  },

  close_url_form: function(){
    
  },

  open_location_form: function(){
    
  },

  close_location_form: function(){
    
  }
})
