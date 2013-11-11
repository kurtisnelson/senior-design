class window.State
  constructor: (@id) ->
          @innings = new Innings
          @strike = new Strike
          @ball = new Ball
          @out = new Out
          @home = new Base("home")
          @first = new Base("first")
          @second = new Base("second")
          @third = new Base("third")

          @home_lineup = new Lineup("home")
          @away_lineup = new Lineup("away")
          @home_players = {}
          @away_players = {}

          @home_score = 0
          @away_score = 0

  update: =>
          jQuery.get("/state/#{@id}.json", null, (data, status, xhr) =>
            @data = data
            #set innings
            @innings.number = data.game.inning.number
            @innings.top = data.game.inning.top
            #set innings count
            if(@innings.top)
              @innings.count = @innings.number * 2
            else
              @innings.count = @innings.number * 2 +1

            if @away_id != data['game']['away_id']
                    @away_id = data['game']['away_id']
                    @update_away()
            if @home_id != data['game']['home_id']
                    @home_id = data['game']['home_id']
                    @update_home()
          )

  update_away: =>
          jQuery.get("/teams/" + @away_id + ".json", (data, status, xhr) =>
            for player in data['players']
              $("#away-list").append(lineup_builder(player))
              @away_players[player['user_id']] = player
          )

  update_home: =>
          jQuery.get("/teams/" + @home_id + ".json", (data, status, xhr) =>
            for player in data['players']
              $("#home-list").append(lineup_builder(player))
              @home_players[player['user_id']] = player
            if(@innings.count > 1)
              console.log "initialize ran"
              @initialize()
          )

  initialize: =>
    $(".lineup>ul>li:nth-child(n+11)").fadeOut()
    $('.sortable').sortable("disable")
    @strike.counter = @data.game.strikes
    @ball.counter  = @data.game.balls
    @out.counter = @data.game.outs
    
    #set start button
    $("#startBtn").fadeOut()
    #set players on base
    if(@innings.top)
      if(@data.game.bases[0] != 0)
        @first.set(@away_players[@data.game.bases[0]])
      if(@data.game.bases[1] != 0)
        @second.set(@away_players[@data.game.bases[1]])
      if(@data.game.bases[2] != 0)
        @third.set(@away_players[@data.game.bases[2]])
    else
      if(@data.game.bases[0] != 0)
        @first.set(@home_players[@data.game.bases[0]])
      if(@data.game.bases[1] != 0)
        @second.set(@home_players[@data.game.bases[1]])
      if(@data.game.bases[2] != 0)
        @third.set(@home_players[@data.game.bases[2]])
    #set home lineup
    for player_id in @data.game.lineups.home
      @home_lineup.batting_order.unshift(@home_players[player_id])
    #set away lineup
    for player_id in @data.game.lineups.away
      @away_lineup.batting_order.unshift(@away_players[player_id])
    #set home score
    @home_score = @data.game.home_score
    #set away score
    @away_score = @data.game.away_score
    console.log ("away_score: " + @away_score)
    @render()

  active_lineup: =>
    return @away_lineup if @innings.top
    @home_lineup
    
  render: =>
    #Render Everything else
    @render_scores()
    @strike.render()
    @ball.render()
    @out.render()
    @first.render()
    @second.render()
    @third.render()
    @active_lineup().next()
    @home.render()

  render_scores: =>
      $(".home-team-score>h1").html(@home_score)
      $(".away-team-score>h1").html(@away_score)
lineup_builder = (player) ->
  "<li class='ui-state-default' data-id=" + player['user_id'] + "> <span class='ui-icon.ui-icon-arrowthick-2-n-s'> </span>" + player['number'] + " " + player['name'] + "</li>"
