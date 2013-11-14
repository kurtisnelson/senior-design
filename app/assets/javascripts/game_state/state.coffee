class window.State
  constructor: (@id) ->
          @innings = new Innings
          @counters = new Counters
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
            @away_id = data['game']['away_id']
            @update_away()
            @home_id = data['game']['home_id']
            @update_home()
            @sync()
            @sync_bases()
          )
          true

  update_away: =>
          jQuery.get("/teams/" + @away_id + ".json", (data, status, xhr) =>
            @away_lineup.counter = 0
            for player in data['players']
              @away_players[player['user_id']] = player
            @away_lineup.batting_order = _.map(@data.game.lineups.away, (i) => @away_players[i])
            Renderer.away_lineup(@)
            @sync_bases() if @active_lineup() == @away_lineup
          )

  update_home: =>
          jQuery.get("/teams/" + @home_id + ".json", (data, status, xhr) =>
            @home_lineup.counter = 0
            for player in data['players']
              @home_players[player['user_id']] = player
            @home_lineup.batting_order = _.map(@data.game.lineups.home, (i) => @home_players[i])
            Renderer.home_lineup(@)
            @sync_bases() if @active_lineup() == @home_lineup
          )

  sync: =>
    @innings.top = @data.game.inning.top
    @innings.set_number @data.game.inning.number
    Renderer.ui(this)
    return unless @innings.number > 0

    @counters.strikes = @data.game.strikes
    @counters.balls  = @data.game.balls
    @counters.outs = @data.game.outs
    Renderer.counters(this)

    @home_score = @data.game.home_score
    @away_score = @data.game.away_score
    Renderer.scores(this)

  sync_bases: =>
    return false if _.isEmpty(@data.game.bases)
    if @innings.top
      active_players = @away_players
    else
      active_players = @home_players

    if(@data.game.bases[0] == 0)
      @first.reset()
    else
      @first.set(active_players[@data.game.bases[0]])
    if(@data.game.bases[1] == 0)
      @second.reset()
    else
      @second.set(active_players[@data.game.bases[1]])
    if(@data.game.bases[2] == 0)
      @third.reset()
    else
      @third.set(active_players[@data.game.bases[2]])
    if @active_lineup().at_bat()
      @home.set(@active_lineup().at_bat())
    Renderer.bases(this)
    true

  active_lineup: =>
    return @away_lineup if @innings.top
    @home_lineup
