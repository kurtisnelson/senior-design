class window.Counters
  constructor: ->
          @outs = 0
          @balls = 0
          @strikes = 0
  strike: =>
          @strikes++
          if @strikes == 3
                  @strikes = 0
                  @balls = 0
  out: =>
          @outs++
          @outs = 0 if @outs == 3
          @balls = 0
          @strikes = 0
  ball: =>
          @balls++
          if @balls >= 4
                  @balls = 0
                  @strikes = 0
  render: =>
          console.log "rendering balls"
          @_counter_render('ball', @balls)
          @_counter_render('strike', @strikes)
          @_counter_render('out', @outs)
          $("p.balls.strikes.outs").html("#{@balls}-#{@strikes} #{@outs}")


  _counter_render: (type, count) =>
          switch count
                  when 0
                    $("##{type}1").hide()
                    $("##{type}2").hide()
                    $("##{type}3").hide()
                  when 1
                    $("##{type}1").fadeIn()
                    $("##{type}2").hide()
                    $("##{type}3").hide()
                  when 2
                    $("##{type}1").fadeIn()
                    $("##{type}2").fadeIn()
                    $("##{type}3").hide()
                  when 3
                    $("##{type}1").fadeIn()
                    $("##{type}2").fadeIn()
                    $("##{type}3").fadeIn()
