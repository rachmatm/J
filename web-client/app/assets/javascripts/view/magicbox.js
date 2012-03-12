window.MagicBoxView = Backbone.View.extend({

  elContainer: $('#main-content'),

  topNavigationTemplate: _.template($('#main-magicbox-navigation-template').html()),

  
  searchTemplate: _.template($('#main-magicbox-navigation-template').html()),
});