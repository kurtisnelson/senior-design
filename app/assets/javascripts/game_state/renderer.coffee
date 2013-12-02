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
      console.log "Rendering UI..."
      if state.innings.number > 0
        $(".lineup>ul>li:nth-child(n+11)").fadeOut()
        $('.sortable').sortable("disable")
        #set start button
        $("#startBtn").fadeOut()
        $("#strikeBtn").fadeIn()
        $("#ballBtn").fadeIn()

        temp = "#{if state.innings.top then 'Top ' else 'Bottom '} #{state.innings.number}"
        console.log temp
        $(".inning .current p").html(temp)
      else
        $("#startBtn").fadeIn()

   @counters: (state) ->
      console.log "Rendering counters..."
      state.counters.render()
   @bases: (state) ->
      console.log "rendering bases..."
      state.first.render()
      if typeof state.first.player[0] == 'undefined'
        $(".bases span.first").removeClass("active")
      else
        $(".bases span.first").addClass("active")
      state.second.render()
      if typeof state.second.player[0] == 'undefined'
        $(".bases span.second").removeClass("active")
      else
        $(".bases span.second").addClass("active")
      state.third.render()
      if typeof state.third.player[0] == 'undefined'
        $(".bases span.third").removeClass("active")
      else
        $(".bases span.third").addClass("active")
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
      console.log "Rendering scores...."
      console.log state.home_score
      console.log state.away_score
      $(".home-team-score>h1").html(state.home_score)
      $(".away-team-score>h1").html(state.away_score)
      $("#home-inning-row [data-number='"+state.innings.number+"']").html(state.innings.score)
      $("#away-inning-row [data-number='"+state.innings.number+"']").html(state.innings.score)
      $(".home_team .score").html(state.home_score)
      $(".away_team .score").html(state.away_score)

lineup_builder = (player) ->
  "<li class='ui-state-default' data-id=" + player['user_id'] + "> <span class='ui-icon.ui-icon-arrowthick-2-n-s'> </span>" + player['number'] + " " + player['name'] + "</li>"
