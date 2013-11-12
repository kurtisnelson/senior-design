class window.Renderer
   @do: (state) ->
      @counters(state)
      @bases(state)
      @home_lineup(state)
      @away_lineup(state)
      @scores(state)
      true
   @counters: (state) ->
      state.counters.render()
   @bases: (state) ->
      state.first.render()
      state.second.render()
      state.third.render()
      state.home.render()

   @away_lineup: (state) ->
      $("#away-list").empty()
      _.each state.away_players, (player) ->
              $("#away-list").append lineup_builder(player)
   @home_lineup: (state) ->
      $("#home-list").empty()
      _.each state.home_players, (player) ->
              $("#home-list").append lineup_builder(player)

   @scores: (state) ->
      $(".home-team-score>h1").html(state.home_score)
      $(".away-team-score>h1").html(state.away_score)

lineup_builder = (player) ->
  "<li class='ui-state-default' data-id=" + player['user_id'] + "> <span class='ui-icon.ui-icon-arrowthick-2-n-s'> </span>" + player['number'] + " " + player['name'] + "</li>"
