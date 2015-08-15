# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@animateLogo = ->
  logoBounce = new Bounce
  logoBounce.translate(
    from:
      x: -300
      y: 0
    to:
      x: 0
      y: 0
    duration: 600
    stiffness: 4).scale(
    from:
      x: 1
      y: 1
    to:
      x: 0.1
      y: 2.3
    easing: 'sway'
    duration: 800
    delay: 65
    stiffness: 2).scale
    from:
      x: 1
      y: 1
    to:
      x: 5
      y: 1
    easing: 'sway'
    duration: 300
    delay: 30
  $ ->
    $('.best-sellers').slick()
    logoBounce.applyTo $('#logo')
    return