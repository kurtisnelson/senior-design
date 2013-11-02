step "I am a user" do 
  @user = FactoryGirl.build(:user)
end

step "I am part of a team" do
  @home_team = FactoryGirl.build(:team)
  @away_team = FactoryGirl.build(:team)
  @player = Player.create
  @player.team = @home_team
  @player.user = @user
  @player.save
end

step "I played in a game with the team" do
  @game = FactoryGirl.build(:game)
  @game.home_team = @home_team
  @game.away_team = @away_team
  @game.save
end

step "I scored a home run in the game" do
  @factory = StatFactory.new(@game.id, 0)
  stat = @factory.homerun @player.id
  stat.category(:name).should eq "Homerun"
end

step "I visit the team's page" do
  visit team_path @home_team
end

step "I click on my name" do
  click_on @user.name
end

step "I can see my homerun updated" do
  page.find('#homeruns', :text => "1")
end

step "I had three outs in the game" do
  @factory = StatFactory.new(@game.id, 0)
  @factory.out @player.id
  @factory.out @player.id
  @factory.out @player.id
end

step "I can see my average updated" do
  page.find('#average', :text => ".25")
end

step "I had three RBIs" do
  @factory = StatFactory.new(@game.id, 0)
  @factory.rbi @player.id
  @factory.rbi @player.id
  @factory.rbi @player.id
end

step "I can see my RBI updated" do
  page.find('td#rbi',  :text => "3")
end

step "I had one walk in the game" do
  @factory = StatFactory.new(@game.id, 0)
  @factory.base_on_balls @player.id
end

step "I can see my OBP updated" do
  page.find('td#obp',  :text => ".4")
end 
