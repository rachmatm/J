window.App = Backbone.View.extend({
    el: 'body',

    initialize: function(){
        this.magicBoxView =  new MagicBoxView;
    },

    render: function(){
        this.magicBoxView.render();
    },

    events: {
        'click .main-about-link': 'open_about'
    },

    open_about: function(){
        this.magicBoxView.open_about();
    }
});

var app = new App;
app.render();