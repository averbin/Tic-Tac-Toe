-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local Board = {{},{},{}}
local BoardElement = {}
local elementsGroup = display.newGroup()
local itemsGroup = display.newGroup()
local uiGroup = display.newGroup()
local run = true

local items = {}
mt = { element, mark}
local turn = "x" -- could be "x" or "o"
local exitButton = display.newRect(
  display.contentWidth - display.contentWidth / 2,
  display.contentHeight - 20 - 30,
  30,
  30)
exitButton:setFillColor(1.0, 0.0, 0.0)

local textTurn = display.newText(uiGroup,
  "Turn: " .. turn,
   display.contentWidth / 2,
   90,
   native.systemFont, 18)

function RetryTapEvent( event )
  EndCleanAll()
  turn = "x"
  run = true
  textTurn.text = "Turn: " .. turn
  --os.exit()
end
exitButton:addEventListener("tap", RetryTapEvent)

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
  for column = 1, #Board do
    local counterForX = {}
    local counterForO = {}
    for row = 1, #Board[column] do
      local boardElement = Board[row][column]
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

function FindByHorizontal()
  for column = 1, #Board do
    local counterForX = {}
    local counterForO = {}
    for row = 1 , #Board[column] do
      local boardElement = Board[column][row]
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

function FindLeftTop()
  local counterForX = {}
  local counterForO = {}
  for i = 1 , #Board do
    if(Board[i][i].mark == "x") then
      counterForX[i] = Board[i][i]
      print("Count: " .. #counterForX)
      if #counterForX == #Board then
        return counterForX
      end
    elseif(Board[i][i].mark == "o") then
      counterForO[i] = Board[i][i]
      if #counterForO == #Board then
        return counterForO
      end
    end
  end
  return {}
end

function FindRightTop()
  local counterForX = {}
  local counterForO = {}
  local column = 1
  for row = #Board , 1, -1 do
    if(Board[column][row].mark == "x") then
      counterForX[row] = Board[column][row]
      if #counterForX == #Board then
        return counterForX
      end
    elseif(Board[column][row].mark == "o") then
      counterForO[row] = Board[column][row]
      if #counterForO == #Board then
        return counterForO
      end
    end
    column = column + 1
  end

  return {}
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
  if run == false then
    return true
  end
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

  local markWinRow = FindByHorizontal()
  if markWinRow ~= nil and markWinRow ~= 0 then
    --TODO : show who win and drow the line.
    --print("row win: " .. row, "Mark: " .. markWinRow)
    textTurn.text = "Won: " .. markWinRow[1].mark
    run = false
    return true
  end

  local markWinColumn = FindByVertical()
  if markWinColumn ~= nil and #markWinColumn ~= 0 then
    --TODO : show who win and drow the line.
    --print("column win: " .. column, "Mark: " .. markWinColumn)
    textTurn.text = "Won: " .. markWinColumn[1].mark
    run = false
    return true
  end

  local markWinLeftTop = FindLeftTop()
  if markWinLeftTop ~= nil and #markWinLeftTop ~= 0 then
    --TODO : show who win and drow the line.
    textTurn.text = "Won: " .. markWinLeftTop[1].mark
    run = false
    return true
  end

  local markWinRightTop = FindRightTop()
  if markWinRightTop ~= nil and #markWinRightTop ~= 0 then
    --TODO : show who win and drow the line.
    textTurn.text = "Won: " .. markWinRightTop[1].mark
    run = false
    return true
  end
  textTurn.text = ("Turn: " .. turn)
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

function CreateBoard()
  local range = 70
  local addH = 0
  local counter = 1

  for row = 1 , 3  do
    local addW = 0
    for column = 1, 3 do
      Board[row][column] = BoardElement.new(
        range * column + addW,
        range * row + addH + 100,
        range,
        tostring(counter))
      counter = counter + 1
      addW = addW + 20
    end
    addH = addH + 20
  end
end

CreateBoard()
