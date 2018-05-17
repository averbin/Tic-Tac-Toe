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

function Board:FindByHorizontal()
  for column = 1, #self do
    local counterForX = {}
    local counterForO = {}
    for row = 1 , #self[column] do
      local boardElement = self[column][row]
      if boardElement.mark == "x" then
        counterForX[row] = boardElement
        if #counterForX == #Board then
          return counterForX -- x win
        end
      elseif boardElement.mark == "o" then
        counterForO[row] = boardElement
        if #counterForO == #Board then
          return counterForO -- o win.
        end
      end
    end
  end

  return nil
end

function Board:FindPairByHorizontal()
  for column = 1, #self do
    local counterForX = {}
    local counterForO = {}
    for row = 1 , #self[column] do
      local boardElement = self[column][row]
      if boardElement.mark == "x" then
        counterForX[row] = boardElement
        if #counterForX == #Board - 1 then
          return counterForX -- x win
        end
      elseif boardElement.mark == "o" then
        counterForO[row] = boardElement
        if #counterForO == #Board - 1 then
          return counterForO -- o win.
        end
      end
    end
  end

  return nil
end

function Board:FindByVertical()
  for column = 1, #self do
    local counterForX = {}
    local counterForO = {}
    for row = 1, #self[column] do
      local boardElement = self[row][column]
      if boardElement.mark == "x" then
        counterForX[row] = boardElement
        if #counterForX == #Board then
          return counterForX
        end
      elseif boardElement.mark == "o" then
        counterForO[row] = boardElement
        if #counterForO == #Board then
          return counterForO
        end
      end
    end
  end

  return nil
end

function Board:FindPairByVertical()
  for column = 1, #self do
    local counterForX = {}
    local counterForO = {}
    for row = 1, #self[column] do
      local boardElement = self[row][column]
      if boardElement.mark == "x" then
        counterForX[row] = boardElement
        if #counterForX == #Board - 1 then
          return counterForX
        end
      elseif boardElement.mark == "o" then
        counterForO[row] = boardElement
        if #counterForO == #Board - 1 then
          return counterForO
        end
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

function Board:FindFromLeftToptoRightBottom()
  local counterForX = {}
  local counterForO = {}
  for i = 1 , #self do
    if(self[i][i].mark == "x") then
      counterForX[i] = self[i][i]
      if #counterForX == #self then
        return counterForX
      end
    elseif(self[i][i].mark == "o") then
      counterForO[i] = self[i][i]
      if #counterForO == #self then
        return counterForO
      end
    end
  end
  return nil
end

function Board:FindPairFromLeftToptoRightBottom()
  local counterForX = {}
  local counterForO = {}
  for i = 1 , #self do
    if(self[i][i].mark == "x") then
      counterForX[i] = self[i][i]
      if #counterForX == #self - 1 then
        return counterForX
      end
    elseif(self[i][i].mark == "o") then
      counterForO[i] = self[i][i]
      if #counterForO == #self - 1 then
        return counterForO
      end
    end
  end
  return nil
end

function Board:FindFromRightToptoBottomLeft()
  local counterForX = {}
  local counterForO = {}
  local row = 1
  for column = #self , 1, -1 do
    if(self[row][column].mark == "x") then
      counterForX[row] = self[row][column]
      if #counterForX == #self then
        return counterForX
      end
    elseif(self[row][column].mark == "o") then
      counterForO[row] = self[row][column]
      if #counterForO == #self then
        return counterForO
      end
    end
    row = row + 1
  end

  return nil
end

function Board:FindPairFromRightToptoBottomLeft()
  local counterForX = {}
  local counterForO = {}
  local row = 1
  for column = #self , 1, -1 do
    if(self[row][column].mark == "x") then
      counterForX[row] = self[row][column]
      if #counterForX == #self then
        return counterForX
      end
    elseif(self[row][column].mark == "o") then
      counterForO[row] = self[row][column]
      if #counterForO == #self then
        return counterForO
      end
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
