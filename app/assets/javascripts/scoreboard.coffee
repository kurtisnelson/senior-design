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
    #base.set_home(this.at_bat)
    home.set(this.at_bat)
    this.counter++
    this.counter= this.counter % 9

class Base
  constructor: (@name) ->
  player: {}
  set: (obj) =>
    this.player = obj
    this.render()
  reset: () =>
    this.player = {}
    this.render()
  is_empty: () =>
    !(Object.getOwnPropertyNames(this.player).length)
  popover_hide: () =>
    $('#'+this.name).popover('hide')
  popover_show: () =>
    $('#'+this.name).popover('show')
  render: () =>
    if(!this.is_empty())
      $("#"+this.name+">h4").text(this.player['id'])
      $("#"+this.name).fadeIn()
      update_popover("#"+this.name , this.player['name'])
    if(this.is_empty())
      $("#"+this.name).fadeOut()

home = new Base("home")
first = new Base("first")
second = new Base("second")
third = new Base("third")

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

@do_start_game = () ->
  $("#startBtn").fadeOut()
  lineup.next()

@do_nextup = () ->
  lineup.next()

@do_single = () ->
  home.popover_hide()
  if(!first.is_empty())
    first.popover_show()
    #TODO wait on click
  first.set(lineup.at_bat)
  home.reset()
  do_nextup()

@do_double = () ->
  home.popover_hide()
  if(!first.is_empty())
    first.popover_show()
  if(!second.is_empty())
    second.popover_show()
    #TODO wait on click
  second.set(lineup.at_bat)
  home.reset()
  do_nextup()

@do_triple = () ->
  home.popover_hide()
  if(!first.is_empty())
    first.popover_show()
  if(!second.is_empty())
    second.popover_show()
  if(!third.is_empty())
    third.popover_show()
    #TODO wait on click
  third.set(lineup.at_bat)
  home.reset()
  do_nextup()


@do_move = (base_on) ->
  if(base_on == 1)
    first.popover_hide();
    second.set(first.player)
    first.reset()
  else if(base_on == 2)
    second.popover_hide()
    third.set(second.player)
    second.reset()
  else if(base_on == 3)
    third.popover_hide()
    third.reset()
    #TODO Update score


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




