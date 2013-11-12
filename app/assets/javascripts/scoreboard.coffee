load "games#score", ->

  #get the game_id from the URL
  game_id = window.location.pathname.split('/')[2]

  @state = new State(game_id)
  pusher = new Pusher(PUSHER_KEY)
  channel = pusher.subscribe("game_state_"+game_id)

  pusher.connection.bind('connected', ->
            state.update()
  )
  pusher.connection.bind('unavailable', ->
            alert("Live connection lost")
  )


  @do_strike = () ->
    #server call
    jQuery.ajax("/state/#{game_id}/strike", {type:'PUT'})
    if state.counters.strikes == 2
      state.home.reset()
      do_out()
    else
      state.counters.strike()
      state.counters.render()

  @do_ball = () ->
    #server call
    jQuery.ajax("/state/#{game_id}/ball", {type:'PUT'})
    #TODO(rfahsel3) call move base on 4th ball
    state.counters.ball()
    state.counters.render()

  @do_out = () ->
    #Server call
    jQuery.ajax("/state/#{game_id}/out", {type:'PUT'})
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
    state.counters.render()

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
    #set Home Lineup array
    console.log state.home_players
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

    console.log lineup_json
    #Server call
    jQuery.ajax("/state/#{game_id}.json", {type:'PATCH', contentType: 'application/json', data: JSON.stringify(lineup_json), dataType: 'json' })
    jQuery.ajax("/state/#{game_id}/start_game", {type:'PUT'})
    $("#startBtn").fadeOut()
    $(".lineup>ul>li:nth-child(n+11)").fadeOut()
    $('.sortable').sortable("disable")
    state.home.set(state.away_lineup.next())
    state.innings.number= 1
    state.innings.top = true
    #innings.count = 2

  @do_nextup = () ->
    state.counters.balls = 0
    state.counters.strikes = 0
    state.counters.render()
    if(state.innings.top)
      console.log "away"
      state.away_lineup.next()
    else
      console.log "home"
      state.home_lineup.next()

  @do_single = () ->
    jQuery.ajax("/state/#{game_id}/single", {type:'PUT'})
    state.home.popover_hide()
    if(!state.first.is_empty())
      state.first.popover_show()
    state.first.set(state.active_lineup().at_bat)
    state.home.reset()
    do_nextup()

  @do_walk = () ->
    #TODO walk server put
    state.home.popover_hide()
    if(!state.first.is_empty())
      state.first.popover_show()
    state.first.set(state.active_lineup().at_bat)
    state.home.reset()
    do_nextup()

  @do_double = () ->
    jQuery.ajax("/state/#{game_id}/double", {type:'PUT'})
    state.home.popover_hide()
    if(!state.first.is_empty())
      state.second.set(state.first.player.shift())
      state.first.render()
    if(!state.second.is_empty())
      state.second.popover_show()
    state.second.set(which_lineup().at_bat)
    state.home.reset()
    do_nextup()

  @do_triple = () ->
    jQuery.ajax("/state/#{game_id}/triple", {type:'PUT'})
    state.home.popover_hide()
    if(!state.second.is_empty())
      state.third.set(state.second.player.shift())
      state.second.render()
    if(!state.first.is_empty())
      state.third.set(state.first.player.shift())
      state.first.render()
    if(!state.third.is_empty())
      state.third.popover_show()
    state.third.set(state.active_lineup().at_bat)
    state.home.reset()
    do_nextup()

  @do_homerun = () ->
    jQuery.ajax("/state/#{game_id}/homerun", {type:'PUT'})
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


  @do_move = (base_on, func) ->
    move_json = {
        player_id: 1
        new_base: base_on+1
        is_steal: 0
      }

    if(func == 1)
      #TODO steal server put
      console.log "steal"
      move_json.is_steal = 1

    if(base_on == 1)
      #update player_id
      move_json.player_id = state.first.player[0]['user_id']
      if(!state.second.is_empty())
        state.second.popover_show()
      state.first.popover_hide()
      state.second.set(state.first.player.shift())
      state.first.render()
    else if(base_on == 2)
      #update player_id
      move_json.player_id = state.second.player[0]['user_id']
      if(!state.third.is_empty())
        state.third.popover_show()
      state.second.popover_hide()
      state.third.set(state.second.player.shift())
      state.second.render()
    else if(base_on == 3)
      #update player_id
      move_json.player_id = state.third.player[0]['user_id']
      if state.third.player.length > 2
        state.third.popover_show()
      else
        state.third.popover_hide()
      do_score()
      state.third.player.shift()
      state.third.render()
    #server call
    jQuery.ajax("/state/#{game_id}/move", {type:'PUT', contentType: 'application/json', data: JSON.stringify(move_json), dataType: 'json' })


  @do_score = () ->
    score_json = {
      topOrBottom: 0
    }
    state.innings.score++
    state.counters.balls = 0
    state.counters.strikes = 0
    state.counters.render()
    if(state.active_lineup().name == "home")
      score_json.topOrBottom = 0
      state.home_score++
      $("#home-inning-row [data-number='"+state.innings.number+"']").html(state.innings.score)
    else if(state.active_lineup().name == "away")
      score_json.topOrBottom = 1
      state.away_score++
      $("#away-inning-row [data-number='"+state.innings.number+"']").html(state.innings.score)
    #server call
    jQuery.ajax("/state/#{game_id}/score", {type:'PUT',contentType: 'application/json', data: JSON.stringify(score_json), dataType: 'json'})


window.update_popover = (id, name) ->
    popover = $(id).data('popover')
    tip = popover.tip()

    popover.options.title = name

    visible = popover && tip && tip.is(':visible')

    if (visible)
      tip.find('.popover-title').text(name)

