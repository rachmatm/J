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
  showProfileEditBio: function(id){
    this.holderView.setElement(this.profile_more_el);
    return this.holderView.renderPrependTo({
      idName: id,
      className: ''
    });
  },
  events: {
    "click .nickname_realname": "open_nickname_realname_form",
    "click .empty_bio_text": "open_bio_form",
    "click .empty_url_text": "open_url_form",
    "click .empty_location_text": "open_location_form",
    "click .account_setting_link": "open_setting"
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template);
    this.profile_more_el = $('#profile-bio-edit');
  },

  open_nickname_realname_form: function(){
    
  },

  close_nickname_realname_form: function(){
    
  },

  open_bio_form: function(){
   
    this.editBioView.setElement(this.showProfileEditBio('main-profile-bio'));
    this.editBioView.render();
    $('.bio_tag').children('.empty_bio_text').hide();


    return false;
  },

  close_bio_form: function(){
    this.editBioView.remove();
  },

  open_url_form: function(){
    alert('url test');
    console.log(this)
    this.editUrlView.render();
    $('.empty_url_field').hide();
  },

  close_url_form: function(){
    
  },

  open_location_form: function(){
     alert('location show test');
  },

  close_location_form: function(){
    
  },
  open_setting : function(){
      alert('open setting')
  },
  close_setting : function(){}
})
