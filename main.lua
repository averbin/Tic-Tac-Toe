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
  --turn = "x"
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
  local row = 1
  for column = #Board , 1, -1 do
    if(Board[row][column].mark == "x") then
      counterForX[row] = Board[row][column]
      if #counterForX == #Board then
        return counterForX
      end
    elseif(Board[row][column].mark == "o") then
      counterForO[row] = Board[row][column]
      if #counterForO == #Board then
        return counterForO
      end
    end
    row = row + 1
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
  if count == #Board * #Board[#Board] then
    return true
  end
  return false
end

function CalculatePoints(elements)
  local firstPoint = { x = 0 , y = 0 }
  local secondPoint = { x = 0, y = 0 }
  local rangeByX = elements[#elements].element.x - elements[1].element.x
  local rangeByY = elements[#elements].element.y - elements[1].element.y
  if rangeByX ~= 0 and rangeByY == 0 then
    -- count horizontal.
    firstPoint.x = elements[1].element.x - elements[1].element.width / 2
    firstPoint.y = elements[1].element.y
    secondPoint.x = elements[#elements].element.x + elements[1].element.width / 2
    secondPoint.y = elements[#elements].element.y
  elseif rangeByY ~= 0 and rangeByX == 0 then
    -- count vertical.
    firstPoint.x = elements[1].element.x
    firstPoint.y = elements[1].element.y - elements[1].element.height / 2
    secondPoint.x = elements[#elements].element.x
    secondPoint.y = elements[#elements].element.y + elements[1].element.height / 2
  else
    -- count other.
    if elements[1].element.x < elements[#elements].element.x then
      -- leftTop -> bottomRight.
      firstPoint.x = elements[1].element.x - elements[#elements].element.width / 2
      firstPoint.y = elements[1].element.y - elements[#elements].element.height / 2
      secondPoint.x = elements[#elements].element.x + elements[#elements].element.width / 2
      secondPoint.y = elements[#elements].element.y + elements[#elements].element.height / 2
    else
      -- rightTop -> bottomLeft.
      firstPoint.x = elements[1].element.x + elements[1].element.width / 2
      firstPoint.y = elements[1].element.y - elements[1].element.height / 2
      secondPoint.x = elements[#elements].element.x - elements[#elements].element.width / 2
      secondPoint.y = elements[#elements].element.y + elements[#elements].element.height / 2
    end
  end
  return firstPoint, secondPoint
end

function DrawTheLine(elements)
  if elements ~= nil and #elements ~= o then
    local startPoint , endPoint = CalculatePoints(elements)
    local lineForWin = display.newLine(itemsGroup, startPoint.x, startPoint.y,
                                      endPoint.x, endPoint.y)
    lineForWin.strokeWidth = 2
    table.insert(items, lineForWin)
  else
    error("Error, the are no elements at all!")
  end
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
    DrawTheLine(markWinRow)
    run = false
    return true
  end

  local markWinColumn = FindByVertical()
  if markWinColumn ~= nil and #markWinColumn ~= 0 then
    --TODO : show who win and drow the line.
    --print("column win: " .. column, "Mark: " .. markWinColumn)
    textTurn.text = "Won: " .. markWinColumn[1].mark
    DrawTheLine(markWinColumn)
    run = false
    return true
  end

  local markWinLeftTop = FindLeftTop()
  if markWinLeftTop ~= nil and #markWinLeftTop ~= 0 then
    --TODO : show who win and drow the line.
    textTurn.text = "Won: " .. markWinLeftTop[1].mark
    DrawTheLine(markWinLeftTop)
    run = false
    return true
  end

  local markWinRightTop = FindRightTop()
  if markWinRightTop ~= nil and #markWinRightTop ~= 0 then
    --TODO : show who win and drow the line.
    textTurn.text = "Won: " .. markWinRightTop[1].mark
    DrawTheLine(markWinRightTop)
    run = false
    return true
  end

  if IsAllMarksSet() then
    textTurn.text = ("Draw")
    run = false
    return true
  end

  textTurn.text = ("Turn: " .. turn)
  return true
end

function BoardElement.new(xpos, ypos, size, name)
  set = {}
  setmetatable(set, { element, mark})
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
