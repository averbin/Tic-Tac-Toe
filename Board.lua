local BoardElement = require "BoardElement"
local Board = {{},{},{}}
Board.mt = {}
setmetatable(Board, Board.mt)

function Board:EndCleanAll()

  for i = 1, #self do
    for j , value in pairs(self[i]) do
      value.mark = ""
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

function Board:FindElement(name)
  for i, v in pairs( self ) do
    for j , value in pairs(v) do
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
  return {}
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

  return {}
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

return Board
