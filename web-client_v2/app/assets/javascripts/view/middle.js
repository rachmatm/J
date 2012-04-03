window.MiddleView = Backbone.View.extend({
  
  initialize: function(){
    this.holderView = new HolderView;
    this.middleSignupView = new MiddleSignupView;
    this.middleWelcomeView = new MiddleWelcomeView;
    this.middleJotView = new MiddleJotView({
      model: this.model
    });
    this.middleLoginCompletionView = new MiddleLoginCompletionView;

    this.middleJotDetailView = new MiddleJotDetailView;
    this.middleProfileView = new MiddleProfileView;
    this.middleSearchResultView = new MiddleSearchResultView;
    this.middleSearchResultJotView = new MiddleSearchResultJotView;
    this.middleNestTemplate = new MiddleNestTemplate;
  },


  createHolder: function(id){
    this.holderView.setElement(this.el);
    this.holderView.render({
      id: id,
      className: 'main-middle-item clearfix'
    });

    return this.holderView.holder_el;
  },

  closeAll: function(){
    $(this.el).children().remove();
  },

  openSignup: function(){
    this.closeAll();
    this.middleSignupView.remove();
    this.middleSignupView.setElement(this.createHolder('main-middle-signup'));
    this.middleSignupView.render();
  },

  openWelcome: function(){
    this.closeAll();
    this.middleWelcomeView.remove();
    this.middleWelcomeView.setElement(this.createHolder('main-middle-welcome'));
    this.middleWelcomeView.render();
  },

  openJot: function(){
    this.closeAll();
    this.middleJotView.setElement(this.createHolder('main-middle-jot'));
    this.middleJotView.render();
  },

  openLoginCompletion: function(data){
    this.closeAll();
    this.middleLoginCompletionView.remove();
    this.middleLoginCompletionView.setElement(this.createHolder('main-middle-login-completion'));
    this.middleLoginCompletionView.render({
      current_user: data.current_user
    });
  },

  openJotDetail: function(data){
    this.closeAll();
    this.middleJotDetailView.remove();
    this.middleJotDetailView.setElement(this.createHolder('main-middle-jot-detail'));
    this.middleJotDetailView.render(data);
  },

  openProfile: function(data){
    this.closeAll();
    this.middleProfileView.remove();
    this.middleProfileView.setElement(this.createHolder('main-middle-profile'));
    this.middleProfileView.render();
  },

  openSearchResult: function(data){
    this.closeAll();
    this.middleSearchResultView.remove();
    this.middleSearchResultView.setElement(this.createHolder('main-middle-search-result'));
    this.middleSearchResultView.render(data);
  },

  openSearchResultJot: function(data){
    this.closeAll();
    this.middleSearchResultJotView.remove();
    this.middleSearchResultJotView.setElement(this.createHolder('main-middle-search-result-jot'));
    this.middleSearchResultJotView.render(data);
  },

  openNest: function(data){
    this.closeAll();
    this.middleNestTemplate.remove();
    this.middleNestTemplate.setElement(this.createHolder('main-middle-nest'));
    this.middleNestTemplate.render(data);
  }
});