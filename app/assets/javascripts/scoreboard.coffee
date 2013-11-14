load "games#score", ->

  #get the game_id from the URL
  game_id = window.location.pathname.split('/')[2]

  @state = new State(game_id)
  pusher = new Pusher(PUSHER_KEY)
  channel = pusher.subscribe("game_state_"+game_id)

  pusher.connection.bind('connected', =>
            $('#connection-status p').text('good')
            state.update()
            @socketId = pusher.connection.socket_id
  )
  pusher.connection.bind('connecting', =>
            $('#connection-status p').text("connecting...")
  )
  pusher.connection.bind('unavailable', =>
            $('#connection-status p').text('disconnected')
            alert("Live connection lost")
  )

  ajax_put = (type, data = {}) ->
    data['socket_id'] = @socketId
    jQuery.ajax("/state/#{game_id}/#{type}", {
            type: 'PUT'
            data: JSON.stringify(data)
            contentType: 'application/json'
            dataType: 'json'
      })

  @do_refresh = ->
    refresh()

  refresh = ->
    @state.update()

  channel.bind('next_inning', refresh)

  @do_strike = ->
    ajax_put('strike')
    strike()

  strike = ->
    if state.counters.strikes == 2
      state.home.reset()
      out()
    else
      state.counters.strike()
      Renderer.counters(state)

  channel.bind('strike', strike)

  @do_ball = ->
    ajax_put('ball')
    ball()

  ball = ->
    state.counters.ball()
    walk() if state.counters.balls == 0
    Renderer.counters(state)

  channel.bind('ball', ball)

  @do_out = () ->
    ajax_put('out')
    out()

  out = ->
    if state.counters.outs == 2
      console.log "out counter is 2"
      state.home.reset()
      state.first.reset()
      state.second.reset()
      state.third.reset()
      state.innings.next()
    else
      do_nextup()
    state.counters.out()
    Renderer.bases(state)
    Renderer.counters(state)

  channel.bind('out', out)

  @do_out_onbase = (base_on) ->
    if(base_on == 0)
      state.home.popover_hide()
      state.home.reset()
      do_out()
      do_nextup()
    else if(base_on == 1)
      state.first.popover_hide()
      state.first.player.shift()
      state.first.render()
      do_out()
    else if(base_on == 2)
      state.second.popover_hide()
      state.second.player.shift()
      state.second.render()
      do_out()
    else if(base_on == 3)
      state.third.popover_hide()
      state.third.player.shift()
      state.third.render()
      do_out()


  @do_start_game = () ->
    # DOM-database
    #set Home Lineup array
    home_array = []
    home_list = $('#home-list li:nth-child(-n+10)')
    home_list.each ->
      player_id = $(@).data('id')
      home_array.push($(@).data('id'))
      state.home_lineup.batting_order.push(state.home_players[player_id])

    #set Away Lineup array
    away_array = []
    away_list = $('#away-list li:nth-child(-n+10)')
    away_list.each ->
      player_id = $(@).data('id')
      away_array.push(player_id)
      state.away_lineup.batting_order.push(state.away_players[player_id])

    lineup_json = {
      lineup:{
        home: home_array
        away: away_array
      }
    }

    #Server call
    jQuery.ajax("/state/#{game_id}.json", {type:'PATCH', contentType: 'application/json', data: JSON.stringify(lineup_json), dataType: 'json' })
    ajax_put('start_game')
    start_game()
    Renderer.do(state)

  start_game = ->
    state.home.set(state.away_lineup.next())
    state.innings.number = 1
    state.innings.top = true
    Renderer.ui(state)

  @do_nextup = ->
    nextup()

  nextup = ->
    state.counters.balls = 0
    state.counters.strikes = 0
    state.active_lineup().next()
    Renderer.counters(state)
    Renderer.bases(state)

  @do_single = () ->
    ajax_put("single")
    single()

  single = ->
    state.home.popover_hide()
    if(!state.first.is_empty())
      state.first.popover_show()
    state.first.set(state.active_lineup().at_bat())
    state.home.reset()
    nextup()

  channel.bind('single', single)

  @do_walk = () ->
    ajax_put('walk')
    walk()

  walk = ->
    state.home.popover_hide()
    if(!state.first.is_empty())
      state.first.popover_show()
    state.first.set(state.active_lineup().at_bat())
    state.home.reset()
    nextup()

  channel.bind('walk', walk)

  @do_double = () ->
    ajax_put('double')
    double()

  double = ->
    state.home.popover_hide()
    if(!state.first.is_empty())
      state.second.set(state.first.player.shift())
      state.first.render()
    if(!state.second.is_empty())
      state.second.popover_show()
    state.second.set(state.active_lineup().at_bat())
    state.home.reset()
    do_nextup()

  channel.bind('double', double)

  @do_triple = () ->
    ajax_put('triple')
    triple()

  triple = ->
    state.home.popover_hide()
    if(!state.second.is_empty())
      state.third.set(state.second.player.shift())
      state.second.render()
    if(!state.first.is_empty())
      state.third.set(state.first.player.shift())
      state.first.render()
    if(!state.third.is_empty())
      state.third.popover_show()
    state.third.set(state.active_lineup().at_bat())
    state.home.reset()
    do_nextup()

  channel.bind("triple", triple)

  @do_homerun = ->
    ajax_put('homerun')
    homerun()

  homerun = ->
    state.home.popover_hide()
    if(!state.second.is_empty())
      state.second.reset()
      do_score()
    if(!state.first.is_empty())
      state.first.reset()
      do_score()
    if(!state.third.is_empty())
      state.third.reset()
      do_score()
    state.home.reset()
    do_score()
    do_nextup()

  channel.bind('homerun', homerun)


  @do_move = (base_on, isSteal) ->
    move_json = {
        player_id: 1
        new_base: base_on+1
        is_steal: isSteal
      }
    #server call
    ajax_put('move', move_json)
    move(move_jsonm isSteal)

  move = (move_json, isSteal) ->

    if(isSteal)
      #TODO steal server put
      console.log "steal"
      move_json.is_steal = 1

    switch move_json['new_base']
      when 2
        #update player_id
        move_json.player_id = state.first.player[0]['user_id']
        if(!state.second.is_empty())
          state.second.popover_show()
        state.first.popover_hide()
        state.second.set(state.first.player.shift())
      when 3
        #update player_id
        move_json.player_id = state.second.player[0]['user_id']
        if(!state.third.is_empty())
          state.third.popover_show()
        state.second.popover_hide()
        state.third.set(state.second.player.shift())
      when 4
        #update player_id
        move_json.player_id = state.third.player[0]['user_id']
        if state.third.player.length > 2
          state.third.popover_show()
        else
          state.third.popover_hide()
        score()
        state.third.player.shift()
    Renderer.bases(state)

  channel.bind('move', move)


  @do_score = ->
    score_json = {
      topOrBottom: 0
    }
    ajax_put('score', score_json)
    score(score_json)

  score = (score_json) ->
    state.innings.score++
    state.counters.balls = 0
    state.counters.strikes = 0
    if(state.active_lineup().name == "home")
      score_json.topOrBottom = 0
      state.home_score++
      $("#home-inning-row [data-number='"+state.innings.number+"']").html(state.innings.score)
    else if(state.active_lineup().name == "away")
      score_json.topOrBottom = 1
      state.away_score++
      $("#away-inning-row [data-number='"+state.innings.number+"']").html(state.innings.score)
    Renderer.counters(state)

  channel.bind('score', score)

window.update_popover = (id, name) ->
    popover = $(id).data('popover')
    tip = popover.tip()

    popover.options.title = name

    visible = popover && tip && tip.is(':visible')

    if (visible)
      tip.find('.popover-title').text(name)

