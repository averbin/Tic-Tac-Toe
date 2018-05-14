local board = require "Board"
local boardElement = require "BoardElement"
local gameData = require "GameData"

BasicAI = {
  markUsesByAI = "o",
  isSinglePlayer = false,
  isTurn = false
}

BasicAI.prototype = { markUsesByAI = "o", isSinglePlayer = false, isTurn = false }
BasicAI.mt = {}
setmetatable( BasicAI, BasicAI.mt)

function BasicAI:SayHello()
  print("Hello")
end

return BasicAI
