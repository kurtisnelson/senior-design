#get the game_id from the URL
game_id = window.location.pathname.split('/')[2]
home_score = 0
away_score = 0
state_json = {}

@innings = 
  count: 0
  number: 0
  top: true
  score: 0
  next: ->
    if(this.number <= 10)
      if(this.score == 0)
        if(which_lineup().name == "home")
          $("#home-inning-row [data-number='"+innings.number+"']").html(innings.score)
        else if(which_lineup().name == "away")
          $("#away-inning-row [data-number='"+innings.number+"']").html(innings.score)
    this.score = 0
    if(this.count >= 19 and home_score != away_score)
      #game over
      console.log "game over"
      $("#strikeBtn").fadeOut()
      $("#ballBtn").fadeOut()
    else
      this.count++
      this.number = Math.floor(this.count / 2)
      if(this.count % 2 == 0)
        this.top= true
      else
        this.top= false
      do_nextup()

strike =
  counter: 0
  process: () ->
    this.counter++
    if this.counter == 3
      this.counter = 0
      ball.reset()
    this.render()
  reset: ->
    this.counter = 0
    this.render()
  render: () ->
    if this.counter == 0
      $("#strike1").hide()
      $("#strike2").hide()
    else if this.counter == 1
      $("#strike1").fadeIn()
    else if this.counter == 2
      $("#strike1").fadeIn()
      $("#strike2").fadeIn()

ball =
  counter: 0
  process: () ->
    this.counter++
    if this.counter == 4
      this.counter = 0
      strike.counter = 0
      strike.render()
      #out.counter=0
      do_walk()
      out.render()
    this.render()
  reset: ->
      this.counter = 0
      this.render()
  render: () ->
    if this.counter == 0
      $("#ball1").hide()
      $("#ball2").hide()
      $("#ball3").hide()
    else if this.counter == 1
      $("#ball1").fadeIn()
    else if this.counter == 2
      $("#ball1").fadeIn()
      $("#ball2").fadeIn()
    else if this.counter == 3
      $("#ball1").fadeIn()
      $("#ball2").fadeIn()      
      $("#ball3").fadeIn()

@out =
  counter: 0
  process: () ->
    this.counter++
    this.counter = 0 if this.counter == 3
    ball.reset()
    strike.reset()
    this.render()
  render: () ->
    if this.counter == 0
      $("#out1").hide()
      $("#out2").hide()
    else if this.counter == 1
      $("#out1").fadeIn()
    else if this.counter == 2
      $("#out1").fadeIn()    
      $("#out2").fadeIn()


class Lineup
  constructor: (@name) ->
    @batting_order = []
    @at_bat = {}
    @counter = 0
  next: () ->
    this.at_bat= this.batting_order[this.counter]
    #base.set_home(this.at_bat)
    home.set(this.at_bat)
    this.counter++
    this.counter= this.counter % 9

class Base
  constructor: (@name) ->
    @player = []
  set: (obj) ->
    this.player.push(obj)
    this.render()
  reset: () ->
    this.player = []
    this.render()
  is_empty: () ->
    #!(Object.getOwnPropertyNames(this.player).length)
    if this.player.length == 0 
      return 1
    else
      return 0 
  popover_hide: () ->
    $('#'+this.name).popover('hide')
  popover_show: () ->
    $('#'+this.name).popover('show')
  render: () ->
    if(!this.is_empty())
      $("#"+this.name+">h4").text(this.player[0]['user_id'])
      $("#"+this.name).fadeIn()
      update_popover("#"+this.name , this.player[0]['name'])
    if(this.is_empty())
      $("#"+this.name).fadeOut()

@home = new Base("home")
@first = new Base("first")
@second = new Base("second")
@third = new Base("third")

@home_lineup = new Lineup("home")
@away_lineup = new Lineup("away")
@home_players = {}
@away_players = {}

stateCallback = (data, status, xhr) ->
  state_json = data
  jQuery.get("/teams/" + data['game']['away_id'] + ".json", awayCallback)
  jQuery.get("/teams/" + data['game']['home_id'] + ".json", homeCallback)

awayCallback = (data, status, xhr) ->
  for player in data['players'] 
    $("#away-list").append(lineup_builder(player))
    #away_lineup.batting_order.push(player)
    away_players[player['user_id']] = player

homeCallback = (data, status, xhr) ->
  for player in data['players'] 
    $("#home-list").append(lineup_builder(player))
    #home_lineup.batting_order.push(player)
    home_players[player['user_id']] = player
  if(innings.count > 1)
    console.log "initialize ran"
    initialize(state_json)

initialize = (data) ->
  strike.counter = data.game.strikes
  ball.counter  = data.game.balls
  out.counter = data.game.outs
  innings.number = data.game.inning.number
  innings.top = data.game.inning.top
   #set innings count
  if(innings.top)
    innings.count = innings.number * 2
  else
    innings.count = innings.number * 2 +1
  #set start button
  if(innings.count > 1)
    $("#startBtn").fadeOut()
  #set players on base
  if(innings.top)
    if(!first.is_empty())
      first.set(away_players[data.game.bases[0]])
    if(!second.is_empty())
      second.set(away_players[data.game.bases[1]])
    if(!third.is_empty())
      third.set(away_players[data.game.bases[2]])
  else
    if(!first.is_empty())
      first.set(home_players[data.game.bases[0]])
    if(!second.is_empty())
      second.set(home_players[data.game.bases[1]])
    if(!third.is_empty())
      third.set(home_players[data.game.bases[2]])
  #set home lineup
  for player_id in data.game.lineups.home
    home_lineup.batting_order.push(home_players[player_id])
  #set away lineup
  for player_id in data.game.lineups.away
    away_lineup.batting_order.push(away_players[player_id])
  #set home score
  home_score = data.game.home_score
  #set away score
  away_score = data.game.away_score

  strike.render()
  ball.render()
  out.render()
  first.render()
  second.render()
  third.render()
  do_nextup()

lineup_builder = (player) ->
  html = "<li class='ui-state-default' data-id=" + player['user_id'] + 
  "> <span class='ui-icon.ui-icon-arrowthick-2-n-s'> </span>" +
  player['number'] + " " +
  player['name'] +
  "</li>"
  return html

# #Get the JSON Object
# $(jQuery.get("/state/" + game_id + ".json", null, stateCallback))
$(jQuery.get("/state/#{game_id}.json", null, stateCallback))

@do_strike = () ->
  #server call
  $(jQuery.ajax("/state/#{game_id}/strike", {type:'PUT'}))
  if strike.counter == 2
    home.reset()
    do_out()
  else
    strike.process()

@do_ball = () ->
  #server call
  $(jQuery.ajax("/state/#{game_id}/ball", {type:'PUT'}))
  #TODO(rfahsel3) call move base on 4th ball
  ball.process()

@do_out = () ->
  #Server call
  #$(jQuery.ajax("/state/#{game_id}/out", {type:'PUT'}))
  if out.counter == 2
    console.log "out counter is 2"
    home.reset()
    first.reset()
    second.reset()
    third.reset()
    innings.next()
  else
    do_nextup()
  out.process()

@do_out_onbase = (base_on) ->
  if(base_on == 0)
    home.popover_hide()
    home.reset()
    do_out()
    do_nextup()
  else if(base_on == 1)
    first.popover_hide()
    first.player.shift()
    first.render()
    do_out()
  else if(base_on == 2)
    second.popover_hide()
    second.player.shift()
    second.render()
    do_out()
  else if(base_on == 3)
    third.popover_hide()
    third.player.shift()
    third.render()
    do_out()


@do_start_game = () ->
  
  #set Home Lineup array
  console.log home_players
  home_array = []
  home_list = $('#home-list li:nth-child(-n+10)')
  home_list.each ->
    player_id = $(@).data('id')
    home_array.push($(@).data('id'))
    home_lineup.batting_order.push(home_players[player_id])

  #set Away Lineup array
  away_array = []
  away_list = $('#away-list li:nth-child(-n+10)')
  away_list.each ->
    player_id = $(@).data('id')
    away_array.push(player_id)
    away_lineup.batting_order.push(away_players[player_id])

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
  $('.sortable').sortable("disable");
  away_lineup.next()
  innings.number= 1
  innings.top = true

@which_lineup = () ->
  if(innings.top)
    return away_lineup
  else
    return home_lineup

@do_nextup = () ->
  ball.reset()
  strike.reset()
  if(innings.top)
    console.log "away"
    away_lineup.next()
  else
    console.log "home"
    home_lineup.next()

@do_single = () ->
  jQuery.ajax("/state/#{game_id}/single", {type:'PUT'})
  home.popover_hide()
  if(!first.is_empty())
    first.popover_show()
  first.set(which_lineup().at_bat)
  home.reset()
  do_nextup()

@do_walk = () ->
  #TODO walk server put
  home.popover_hide()
  if(!first.is_empty())
    first.popover_show()
  first.set(which_lineup().at_bat)
  home.reset()
  do_nextup()

@do_double = () ->
  jQuery.ajax("/state/#{game_id}/double", {type:'PUT'})
  home.popover_hide()
  if(!first.is_empty())
    second.set(first.player.shift())
    first.render()
  if(!second.is_empty())
    second.popover_show()
  second.set(which_lineup().at_bat)
  home.reset()
  do_nextup()

@do_triple = () ->
  jQuery.ajax("/state/#{game_id}/triple", {type:'PUT'})
  home.popover_hide()
  if(!second.is_empty())
    third.set(second.player.shift())
    second.render()
  if(!first.is_empty())
    third.set(first.player.shift())
    first.render()
  if(!third.is_empty())
    third.popover_show()
  third.set(which_lineup().at_bat)
  home.reset()
  do_nextup()

@do_homerun = () ->
  jQuery.ajax("/state/#{game_id}/homerun", {type:'PUT'})
  home.popover_hide()
  if(!second.is_empty())
    second.reset()
    do_score()
  if(!first.is_empty())
    first.reset()
    do_score()
  if(!third.is_empty())
    third.reset()
    do_score()
  home.reset()
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
    move_json.player_id = first.player[0]['user_id']
    if(!second.is_empty())
      second.popover_show()
    first.popover_hide();
    second.set(first.player.shift())
    first.render()
    #first.reset()
  else if(base_on == 2)
    #update player_id
    move_json.player_id = second.player[0]['user_id']
    if(!third.is_empty())
      third.popover_show()
    second.popover_hide()
    third.set(second.player.shift())
    second.render()
    #second.reset()
  else if(base_on == 3)
    #update player_id
    move_json.player_id = third.player[0]['user_id']
    if third.player.length > 2
      third.popover_show()
    else
      third.popover_hide()
    do_score()
    third.player.shift()
    third.render()
  #server call
  jQuery.ajax("/state/#{game_id}/move", {type:'PUT', contentType: 'application/json', data: JSON.stringify(move_json), dataType: 'json' })


    
@do_score = () ->
  score_json = {
    topOrBottom: 0
  }
  innings.score++
  ball.reset()
  strike.reset()
  if(which_lineup().name == "home")
    score_json.topOrBottom = 0
    home_score++
    $(".home-team-score>h1").html(home_score)
    $("#home-inning-row [data-number='"+innings.number+"']").html(innings.score)
  else if(which_lineup().name == "away")
    score_json.topOrBottom = 1
    away_score++
    $(".away-team-score>h1").html(away_score)
    $("#away-inning-row [data-number='"+innings.number+"']").html(innings.score)
  #server call
  jQuery.ajax("/state/#{game_id}/score", {type:'PUT',contentType: 'application/json', data: JSON.stringify(score_json), dataType: 'json'})


#Render Helper Function

#is_empty = (obj) ->
 # !(Object.getOwnPropertyNames(obj).length)

update_popover = (id, name) ->
  popover = $(id).data('popover')
  tip = popover.tip();

  popover.options.title = name

  visible = popover && tip && tip.is(':visible')

  if (visible)
    tip.find('.popover-title').text(name)

