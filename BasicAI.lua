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

    local element = nil
    if self.difficulty == "easy" then
      print("Easy Mode")
      element = self.PrimitiveAI()
    elseif self.difficulty == "normal" then
      print("Normal Mode")
      element = self.DefenderAI()
    else
      print("Hard Mode")
      element = self.Attacker()
    end

    if element == nil then
      element = BasicAI:PrimitiveAI()
    end

    return element

  end
end

function BasicAI:Attacker()
  local elementDef = BasicAI:DefenderAI()
  local element = nil

  element = BasicAI:FindElementForAttack()

  if element == nil then
    element = elementDef
  end

  return element
end

function BasicAI:DefenderAI()
  local element = nil
  -- find first player pairs.
  element = BasicAI:FindElementForProtection()

  return element
end

function BasicAI:FindElementHorizontal(mark)
  local pairElements = nil
  local element = nil
  for i = 1 , #board do
    if board:IsAllMarksSetOnRow(i) == false then
      pairElements = board:FindByHorizontalPair(i, mark)
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

function BasicAI:FindElementVertical(mark)
  local pairElement = nil
  local element = nil

  for i = 1 , #board do
    if board:IsAllMarksSetOnColumn(i) == false then
      pairElements = board:FindByVerticalPair(i, mark)
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

function BasicAI:FindElementLeftTopRightBottom(mark)
  local element = nil
  if board:IsAllMarksSetOnLeftTopRightBottom() == true then
    return element
  end

  local line = board:GetLeftTopRightBottomLine()
  pairElements = board:FindFromLeftTopRightBottomPair(
    line, mark)

  if pairElements ~= nil and #pairElements ~= 0 then

    for i = 1, #line do
      if line[i].mark == "" then
        element = board:FindElement(line[i].element.name)
      end
    end
  end

  return element
end

function BasicAI:FindElementRightTopLeftBottom(mark)
  local element = nil
  if board:IsAllMarksSetOnRightTopLeftBottom() == true then
    return element
  end

  local line = board:GetRightTopleftBottomLine()
  pairElements = board:FindFromRightToptoBottomLeftPair(
    line, mark)

  if pairElements ~= nil and #pairElements ~= 0 then

    for i = 1, #line do
      if line[i].mark == "" then
        element = board:FindElement(line[i].element.name)
      end
    end
  end

  return element
end

function BasicAI:FindElementForAttack()
  local element = nil

  element = BasicAI:FindElementHorizontal(gameData.secondPlayer)

  if element == nil then
    element = BasicAI:FindElementVertical(gameData.secondPlayer)
  end

  if element == nil then
    element = BasicAI:FindElementLeftTopRightBottom(gameData.secondPlayer)
  end

  if element == nil then
    element = BasicAI:FindElementRightTopLeftBottom(gameData.secondPlayer)
  end

  return element
end

function BasicAI:FindElementForProtection()
  local element = BasicAI:FindElementHorizontal(gameData.firstPlayer)
  if element == nil then
    element = BasicAI:FindElementVertical(gameData.firstPlayer)
  end

  if element == nil then
    element = BasicAI:FindElementLeftTopRightBottom(gameData.firstPlayer)
  end

  if element == nil then
    element = BasicAI:FindElementRightTopLeftBottom(gameData.firstPlayer)
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
