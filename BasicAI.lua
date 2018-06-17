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

function BasicAI:ComputerStep()
  if gameData.turn == gameData.secondPlayer and gameData.run == true then
    self.isTurn = false
    print(gameData.turn)
    return self.DefenderAI()
  end
end

function BasicAI:DefenderAI()
  local element = nil
  -- find first player pairs.
  element = BasicAI:FindPairElements()
  if element == nil then
    element = BasicAI:PrimitiveAI()
  end

  return element
end

function BasicAI:FindElementHorizontal()
  local pairElements = nil
  local element = nil
  for i = 1 , #board do
    if board:IsAllMarksSetOnRow(i) == false then
      pairElements = board:FindByHorizontalPair(i, gameData.firstPlayer)
      if pairElements ~= nil and #pairElements ~= 0 then
        while true do
          local startElement = board[i][1].element.name
          local endElement = board[i][#board].element.name
          element = board:FindElement(math.random(startElement, endElement))
          if element ~= nil and element.mark == "" then
            return element
          end
        end
      end
    end
  end

  return element
end

function BasicAI:FindElementVertical()
  local pairElement = nil
  local element = nil

  for i = 1 , #board do
    if board:IsAllMarksSetOnColumn(i) == false then
      pairElements = board:FindByVerticalPair(i, gameData.firstPlayer)
      local line = board:GetVerticalLine(i)
      if pairElements ~= nil and #pairElements ~= 0 then
        for i = 1, #line do
          if line[i].mark == "" then
            element = board:FindElement(line[i].element.name)
          end
        end
      end
    end
  end

  return element
end

function BasicAI:FindPairElements()
  local element = BasicAI:FindElementHorizontal()
  if element == nil then
    element = BasicAI:FindElementVertical()
  end
  return element
end

function BasicAI:PrimitiveAI()
  -- Based on random.
  while true do
    local element = board:FindElement(math.random(1, 9))
    if element ~= nil and element.mark == "" then
      return element
    end
  end
end

return BasicAI
