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

function BasicAI:FindElementUseRandom()
  while true do
    local element = board:FindElement(math.random(1, 9))
    if element ~= nil and element.mark == "" then
      return element
    end
  end
end

function BasicAI:BasicComputer()
  if gameData.turn == gameData.secondPlayer and gameData.run == true then
    self.isTurn = false
    print(gameData.turn)
    return self.FindElementUseRandom()
  end
end

return BasicAI
