class Stat < ActiveRecord::Base
	belongs_to :user
	belongs_to :game

  enumerate :category do
    value id: 0, name: "Single"
    value id: 1, name: "Double"
    value id: 2, name: "Triple"
    value id: 3, name: "Steal"
    value id: 4, name: "Homerun"
    value id: 5, name: "RBI"
    value id: 6, name: "Out"
    value id: 7, name: "Strike Out"
    value id: 8, name: "Base on Balls"
  end
end
