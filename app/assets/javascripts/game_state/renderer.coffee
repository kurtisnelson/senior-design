class window.Renderer
   @do: (state) ->
      @ui(state)
      @counters(state)
      @bases(state)
      @home_lineup(state)
      @away_lineup(state)
      @scores(state)
      true
   @ui: (state) ->
      if state.innings.number > 0
        $(".lineup>ul>li:nth-child(n+11)").fadeOut()
        $('.sortable').sortable("disable")
        #set start button
        $("#startBtn").fadeOut()

   @counters: (state) ->
      state.counters.render()
   @bases: (state) ->
      state.first.render()
      state.second.render()
      state.third.render()
      state.home.render()

   @away_lineup: (state) ->
      $("#away-list").empty()
      lineup = state.away_lineup.batting_order
      if(_.isEmpty? lineup)
        lineup = state.away_players

      _.each lineup, (player) ->
              $("#away-list").append lineup_builder(player)
   @home_lineup: (state) ->
      $("#home-list").empty()
      lineup = state.home_lineup.batting_order
      if(_.isEmpty? lineup)
        lineup = state.home_players

      _.each lineup, (player) ->
              $("#home-list").append lineup_builder(player)

   @scores: (state) ->
      $(".home-team-score>h1").html(state.home_score)
      $(".away-team-score>h1").html(state.away_score)

lineup_builder = (player) ->
  "<li class='ui-state-default' data-id=" + player['user_id'] + "> <span class='ui-icon.ui-icon-arrowthick-2-n-s'> </span>" + player['number'] + " " + player['name'] + "</li>"
