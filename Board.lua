local BoardElement = require "BoardElement"
local Board = {{},{},{}}
Board.mt = {}
setmetatable(Board, Board.mt)

function Board:CreateBoard(ui_group, event)
  local range = 70
  local addH = 0
  local counter = 1

  for row = 1 , 3  do
    local addW = 0
    for column = 1, 3 do
      self[row][column] = BoardElement.new(
        ui_group,
        range * column + addW,
        range * row + addH + 100,
        range,
        event,
        tostring(counter))
      counter = counter + 1
      addW = addW + 20
    end
    addH = addH + 20
  end
end

function Board:CleanBoard()
  for i = 1, #self do
    for j , value in pairs(self[i]) do
      value.mark = ""
    end
  end
end

function Board:DeleteElements()
  for i = 1, #self * #self[1] do
      local boardElement = self:FindElement(i)
      if boardElement ~= nil then
        boardElement.element:removeSelf()
      end
  end
end

function Board:MatchElements(boardElement, range, counterForX, counterForO, counter)
  if boardElement.mark == "x" then
    counterForX[counter] = boardElement
    if #counterForX == range then
      return counterForX
    end
  elseif boardElement.mark == "o" then
    counterForO[counter] = boardElement
    if #counterForO == range then
      return counterForO
    end
  end
  return nil
end

function Board:FindByHorizontal(range)
  for column = 1, #self do
    local counterForX = {}
    local counterForO = {}
    for row = 1 , #self[column] do
      local boardElement = self[column][row]
      local elements = Board:MatchElements(boardElement, range,
       counterForX, counterForO, row)
      if elements ~= nil then
        return elements
      end
    end
  end

  return nil
end

function Board:FindByHorizontalPair(row, mark)
  local line = Board[row]
  local count = 0
  local pair = {}
  for i = 1, #line do
    if line[i].mark == mark then
      count = count + 1
      pair[count] = line[i]
      if #pair == #line - 1 then
        return pair
      end
    end
  end
  return nil
end

function Board:FindByVerticalPair()

end

function Board:FindByVertical(range)
  for column = 1, #self do
    local counterForX = {}
    local counterForO = {}
    for row = 1, #self[column] do
      local boardElement = self[row][column]
      local elements = Board:MatchElements(boardElement, range,
       counterForX, counterForO, row)
      if elements ~= nil then
        return elements
      end
    end
  end

  return nil
end

function Board:FindElement(name)
  for i = 1, #self do
    for j = 1 , #self[i] do
      value = self[i][j]
      if type(name) == "number" then
        name = tostring(name)
      end
      if value.element.name == name then
        return value
      end
    end
  end
end

function Board:FindFromLeftToptoRightBottom(range)
  local counterForX = {}
  local counterForO = {}
  for i = 1 , #self do
    local boardElement = self[i][i]
    local elements = Board:MatchElements(boardElement, range,
     counterForX, counterForO, i)
    if elements ~= nil then
      return elements
    end
  end
  return nil
end

function Board:FindFromRightToptoBottomLeft(range)
  local counterForX = {}
  local counterForO = {}
  local row = 1
  for column = #self , 1, -1 do
    local boardElement = self[row][column]
    local elements = Board:MatchElements(boardElement, range,
     counterForX, counterForO, row)
    if elements ~= nil then
      return elements
    end
    row = row + 1
  end

  return nil
end

function Board:IsAllMarksSet()
  local count = 0
  for i = 1, #self do
    for j = 1 , #self[i] do
      if self[i][j].mark ~= "" then
        count = count + 1
      end
    end
  end
  if count == #self * #self[#self] then
    return true
  end
  return false
end

function Board:IsAllMarksSetOnRow(rowNum)
  local counter = 0

  for i = 1, #self do
    if self[rowNum][i].mark ~= "" then
      counter = counter + 1
    end
  end

  if counter == #self then
    return true
  end
  return false
end

function Board:IsAllMarksSetOnColumn(columnNum)
  local counter = 0

  for i = 1, #self do
    if self[i][columnNum].mark ~= "" then
      counter = counter + 1
    end
  end

  if counter == #self then
    return true
  end
  return false
end

function Board:SetTransaction()
  local counter = 5
  for i = 1, #self do
    for j = 1 , #self[i] do
        local placeToGo = self[i][j].element.y
        self[i][j].element.y = 0
        transition.to( self[i][j].element, { time = counter, y = placeToGo, transition=easing.outQuint  } )
        counter = counter + counter
    end
  end
end

return Board
