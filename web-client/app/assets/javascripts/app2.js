window.App = Backbone.View.extend({

    el: 'body',

    initialize: function(){
        this.magicBoxPrivateView = new MagicBoxPrivateView;
    },

    render: function(){
        this.magicBoxPrivateView.render();
    },

    events: {
        'click .main-about-link': 'open_about'
    },

    open_about: function(){
        this.magicBoxPrivateView.open_about();
    }
});

var app = new App;
app.render();