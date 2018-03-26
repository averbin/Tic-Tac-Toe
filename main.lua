-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local Board = {{},{},{}}
local BoardElement = {}
local elementsGroup = display.newGroup()
local itemsGroup = display.newGroup()
local items = {}
mt = { element, mark}
local turn = "x" -- could be "x" or "o"
local exitButton = display.newRect(display.contentWidth - 50, 20, 30, 30)
exitButton:setFillColor(1.0, 0.0, 0.0)
function ExitTapEvent( event )
  EndCleanAll()
  turn = "x"
  --os.exit()
end
exitButton:addEventListener("tap", ExitTapEvent)

function FindElement(name)
  print("Searching element: " .. name)
  for i, v in pairs( Board ) do
    for j , value in pairs(v) do
      if value.element.name == name then
        return value
      end
    end
  end
end

function FindByVertical()
  local columnCounter = #Board[1]
  for column = 1, columnCounter do
    local counterForX = 0
    local counterForO = 0
    for row = 1, #Board[column] do
      boardElement = Board[row][column]
      if boardElement.mark == "x" then
        counterForX = counterForX + 1
        if counterForX == #Board then
          return "x", column
        end
      elseif boardElement.mark == "o" then
        counterForO = counterForO + 1
        if counterForO == #Board then
          return "o", column
        end
      end
    end
  end

  return "", 0
end

function FindByHorizontal()
  for i, v in pairs( Board ) do
    local counterForX = 0
    local counterForO = 0
    for j , value in pairs(v) do
      if value.mark == "x" then
        counterForX = counterForX + 1
        if counterForX == 3 then
          return "x", i -- x win.
        end
      elseif value.mark == "o" then
        counterForO = counterForO + 1
        if counterForO == 3 then
          return "o", i -- y win.
        end
      end
    end
  end
  return "", 0
end

function FindLeftTop()
  local counterForX = 0
  local counterForO = 0
  for i = 1 , #Board do
    if(Board[i][i].mark == "x") then
      counterForX = counterForX + 1
      if counterForX == #Board then
        return "x" , i
      end
    elseif(Board[i][i].mark == "o") then
      counterForO = counterForO + 1
      if counterForO == #Board then
        return "o" , i
      end
    end
  end
  return "", 0
end

function FindRightTop()
  local counterForX = 0
  local counterForO = 0
  local row = 1
  for column = #Board , 1, -1 do
    print("position: " .. row .. " : " .. column)
    if(Board[row][column].mark == "x") then
      counterForX = counterForX + 1
      if(counterForX == #Board) then
        return "x", row
      end
    elseif(Board[row][column].mark == "o") then
      counterForO = counterForO + 1
      if(counterForO == #Board) then
        return "o", row
      end
    end
    row = row + 1
  end

  return "", 0
end

function DrawCircle(xPos, yPos)
  local circle = display.newCircle(itemsGroup, xPos, yPos, 20 )
  circle:setFillColor( 0.2 )
  circle.strokeWidth = 2
  circle:setStrokeColor( 1, 1, 1 )
  table.insert(items, circle)
end

function DrawLines(xPos, yPos)
  --xLines = {{},{}}
  local range = 20
  local firstLine = display.newLine(itemsGroup, xPos - range, yPos - range, xPos + range, yPos + range)
  firstLine.strokeWidth = 2
  local secondLine = display.newLine(itemsGroup, xPos + range, yPos - range, xPos - range, yPos + range)
  secondLine.strokeWidth = 2
  table.insert(items, firstLine)
  table.insert(items, secondLine)
end

function EndCleanAll()
  RemoveAllItems()
  for i, v in pairs( Board ) do
    for j , value in pairs(v) do
      value.mark = ""
    end
  end
end

function RemoveAllItems()
  for i = #items, 1, -1 do
    object = items[i]
    display.remove(object)
    table.remove( items, i )
  end
end

function IsAllMarksSet()
  local count = 0
  for i, v in pairs( Board ) do
    for j , value in pairs(v) do
      if value.mark ~= "" then
        count = count + 1
      end
    end
  end
  if count == 9 then
    return true
  end
  return false
end

function tapEvent( event )
  print("tap: " .. event.target.name)
  print("pos: " .. event.target.x .. "\ty: " .. event.target.y)
  boardElement = FindElement(event.target.name)
  if boardElement.mark == "" then
    print("Turn: " .. turn)
    if turn == "x" then
      boardElement.mark = "x"
      DrawLines(event.target.x, event.target.y)
      turn = "o"
    else
      boardElement.mark = "o"
      DrawCircle(event.target.x, event.target.y)
      turn = "x"
    end
  else
    print("Exists: ".. event.target.name .. "\t" .. boardElement.mark)
  end

  local markWinRow , row = FindByHorizontal()
  if markWinRow ~= "" then
    --TODO : show who win and drow the line.
    print("row win: " .. row, "Mark: " .. markWinRow)
  end

  local markWinColumn , column = FindByVertical()
  if markWinColumn ~= "" then
    --TODO : show who win and drow the line.
    print("column win: " .. column, "Mark: " .. markWinColumn)
  end

  local markWinLeftTop , index = FindLeftTop()
  if markWinLeftTop ~= "" then
    --TODO : show who win and drow the line.
    print("LeftTop win: " .. index, "Mark: " .. markWinLeftTop)
  end

  local markWinRightTop , index = FindRightTop()
  if markWinRightTop ~= "" then
    --TODO : show who win and drow the line.
    print("LeftTop win: " .. index, "Mark: " .. markWinRightTop)
  end
  return true
end

function BoardElement.new(xpos, ypos, size, name)
  set = {}
  setmetatable(set, mt)
  set.mark = ""
  set.element = display.newRect(elementsGroup, xpos, ypos, size, size);
  set.element:setFillColor(0.2)
  set.element:addEventListener("tap", tapEvent)
  set.element.name = name
  return set
end

local range = 70

local addH = 0
local counter = 1
for j = 1 , 3  do
  local addW = 0
  for i = 1, 3 do
    Board[j][i] = BoardElement.new(range * i + addW, range * j + addH + 100, range, tostring(counter))
    counter = counter + 1
    addW = addW + 20
  end
  addH = addH + 20
end
