local board = require "Board"
local boardElement = require "BoardElement"
local gameData = require "GameData"

BasicAI = {
  markUsesByAI = "o",
  isSinglePlayer = false,
  isTurn = false,
  difficulty = "easy" -- "easy", "normal" and "hard"
}

BasicAI.prototype = { markUsesByAI = "o",
  isSinglePlayer = false,
  isTurn = false ,
  difficulty = "easy"
}

BasicAI.mt = {}
setmetatable( BasicAI, BasicAI.mt)

function BasicAI:SetupMarkOnBoard()
end

function BasicAI:BasicComputer()
  if gameData.turn == gameData.secondPlayer then
    self.isTurn = false
    print(gameData.turn)
    gameData.turn = "x"
  end
end

return BasicAI
