#get the game_id from the URL
game_id = window.location.pathname.split('/')[2]

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
      out.counter=0
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

out =
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


lineup =
  batting_order: []
  at_bat: {}
  counter: 0
  next: () ->
    this.at_bat= this.batting_order[this.counter]
    base.set_home(this.at_bat)
    this.counter++
    this.counter= this.counter % 9

base =
  first: {}
  second: {}
  third: {}
  home: {}
  set_first: (player) ->
    #put player on first
    this.first = player
    this.render()
  set_second: (player) ->
    #put player on first
    this.second = player
    this.render()
  set_third: (player) ->
    #put player on first
    this.third = player
    this.render()
  set_home: (player) ->
    #put player on first
    this.home = player
    this.render()
  render: () ->
    if(!is_empty(this.first))
      $("#first>h4").text(this.first['id'])
      $("#first").fadeIn()
      update_popover("#first", this.first['name'])
    if(!is_empty(this.second))
      $("#second>h4").text(this.second['id'])
      $("#second").fadeIn()
      update_popover("#second", this.second['name'])
    if(!is_empty(this.third))
      $("#third>h4").text(this.third['id'])
      $("#third").fadeIn()
      update_popover("#third", this.third['name'])
    if(!is_empty(this.home))
      $("#home>h4").text(this.home['id'])
      $("#home").fadeIn()
      update_popover("#home", this.home['name'])


stateCallback = (data, status, xhr) ->
  for person in data['players']
    lineup.batting_order.push(person)

  strike.counter = data['game']['strikes']
  ball.counter  = data['game']['balls']
  out.counter = data['game']['outs']
  strike.render()
  ball.render()
  out.render()

# #Get the JSON Object
# $(jQuery.get("/state/" + game_id + ".json", null, stateCallback))
$(jQuery.get("/state/#{game_id}.json", null, stateCallback))

@debug =() ->
  console.log(strike.counter)
  strike.render()

@do_strike = () ->
  #server call
  $(jQuery.ajax("/state/#{game_id}/strike", {type:'PUT'}))
  if strike.counter == 2
    out.process()
  else
    strike.process()

@do_ball = () ->
  #server call
  $(jQuery.ajax("/state/#{game_id}/ball", {type:'PUT'}))
  #TODO(rfahsel3) call move base on 4th ball
  ball.process()

@do_out = () ->
  #Server call
  $(jQuery.ajax("/state/#{game_id}/out", {type:'PUT'}))
  #TODO next_innint if out.counter = 2
  out.process()

@do_nextup = () ->
  lineup.next()

@do_single = () ->
  base.set_first(lineup.at_bat)
  $("#home").fadeOut()

#Render Helper Function

is_empty = (obj) ->
  !(Object.getOwnPropertyNames(obj).length)

update_popover = (id, name) ->
  popover = $(id).data('popover')
  tip = popover.tip();

  popover.options.title = name

  visible = popover && tip && tip.is(':visible')

  if (visible)
    tip.find('.popover-title').text(name)




