window.MiddleAboutView = Backbone.View.extend({

  template: _.template($('#about-template').html()),

  render: function(){
    var _this = this;

    $(this.el).html(this.template());

    $('.faq_content_toggle').click(function(){
      $(this).parent().find('p').toggle();
    });

    $('.about_jotky').show();
  },

  events: {
    'click .about_default': 'open_about',
    'click .what_jotky_default': 'open_what',
    'click .faq_default': 'open_faq',
    'click .about_bottom_link': 'open_about',
    'click .what_jotky_bottom_link': 'open_what',
    'click .faq_bottom_link': 'open_faq'
  },

  open_about: function(){
    $('.what_jotky_default').removeClass('about_active');
    $('.faq_default').removeClass('about_active');

    $('.about_default').addClass('about_active');

    $('.what_jotky').hide();
    $('.faq_jotky').hide();

    $('.about_jotky').show();
  },

  open_what: function(){
    $('.about_default').removeClass('about_active');
    $('.faq_default').removeClass('about_active');

    $('.what_jotky_default').addClass('about_active');

    $('.about_jotky').hide();
    $('.faq_jotky').hide();

    $('.what_jotky').show();
  },

  open_faq: function(){
    $('.about_default').removeClass('about_active');
    $('.what_jotky_default').removeClass('about_active');

    $('.faq_default').addClass('about_active');

    $('.about_jotky').hide();
    $('.what_jotky').hide();

    $('.faq_jotky').show();
  }
})
