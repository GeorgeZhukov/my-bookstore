// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require slick
//= require jquery.raty
//= require intlTelInput
//= require bounce.min
//= require_tree .

var logoBounce = new Bounce();
logoBounce.
    translate({
        from: {x: -300, y: 0},
        to: {x: 0, y: 0},
        duration: 600,
        stiffness: 4
    })
    .scale({
        from: {x: 1, y: 1},
        to: {x: 0.1, y: 2.3},
        easing: "sway",
        duration: 800,
        delay: 65,
        stiffness: 2
    })
    .scale({
        from: {x: 1, y: 1},
        to: {x: 5, y: 1},
        easing: "sway",
        duration: 300,
        delay: 30,
    });

var navbarBounce = new Bounce();
navbarBounce.
    translate({
        from: {x: 300, y: 0},
        to: {x: 0, y: 0},
        duration: 600,
        stiffness: 4
    })
    .scale({
        from: {x: 1, y: 1},
        to: {x: 0.1, y: 2.3},
        easing: "sway",
        duration: 800,
        delay: 65,
        stiffness: 2
    })
    .scale({
        from: {x: 1, y: 1},
        to: {x: 5, y: 1},
        easing: "sway",
        duration: 300,
        delay: 30,
    });

var bookBounce = new Bounce();
bookBounce.
    skew({
        from: {x: 0, y: 0},
        to: {x: 40, y: 60},
        easing: "sway",
        duration: 750,
        bounces: 4
    }).scale({
        from: {x: 0.5, y: 0.5},
        to: {x: 1, y: 1},
        easing: "bounce",
        duration: 750,
        bounces: 4
    });


$(function () {
    // Bounce logo
    logoBounce.applyTo($("#logo"));
    bookBounce.applyTo($(".book"));
    navbarBounce.applyTo($(".navbar-right"));
});