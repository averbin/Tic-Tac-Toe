-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local Board = require "Board"
local BoardElement = require "BoardElement"
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
  RemoveAllItems()
  Board:CleanBoard()
  turn = "x"
  run = true
  textTurn.text = "Turn: " .. turn
  --os.exit()
end
exitButton:addEventListener("tap", RetryTapEvent)

function DrawCircle(xPos, yPos)
  local circle = display.newCircle(itemsGroup, xPos, yPos, 20 )
  circle:setFillColor( 0.2 )
  circle.strokeWidth = 2
  circle:setStrokeColor( 1, 1, 1 )
  table.insert(items, circle)
end

function DrawEx(xPos, yPos)
  --xLines = {{},{}}
  local range = 20
  local firstLine = display.newLine(itemsGroup, xPos - range, yPos - range, xPos + range, yPos + range)
  firstLine.strokeWidth = 2
  local secondLine = display.newLine(itemsGroup, xPos + range, yPos - range, xPos - range, yPos + range)
  secondLine.strokeWidth = 2
  table.insert(items, firstLine)
  table.insert(items, secondLine)
end

function RemoveAllItems()
  for i = #items, 1, -1 do
    object = items[i]
    display.remove(object)
    table.remove( items, i )
  end
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

  boardElement = Board:FindElement(event.target.name)
  if boardElement.mark == "" then
    print("Turn: " .. turn)
    if turn == "x" then
      boardElement.mark = "x"
      DrawEx(event.target.x, event.target.y)
      turn = "o"
    else
      boardElement.mark = "o"
      DrawCircle(event.target.x, event.target.y)
      turn = "x"
    end
  else
    print("Exists: ".. event.target.name .. "\t" .. boardElement.mark)
  end

  local markWinRow = Board:FindByHorizontal()
  if markWinRow ~= nil and markWinRow ~= 0 then
    textTurn.text = "Won: " .. markWinRow[1].mark
    DrawTheLine(markWinRow)
    run = false
    return true
  end

  local markWinColumn = Board:FindByVertical()
  if markWinColumn ~= nil and #markWinColumn ~= 0 then
    textTurn.text = "Won: " .. markWinColumn[1].mark
    DrawTheLine(markWinColumn)
    run = false
    return true
  end

  local markWinLeftTop = Board:FindFromLeftToptoRightBottom()
  if markWinLeftTop ~= nil and #markWinLeftTop ~= 0 then
    textTurn.text = "Won: " .. markWinLeftTop[1].mark
    DrawTheLine(markWinLeftTop)
    run = false
    return true
  end

  local markWinRightTop = Board:FindFromRightToptoBottomLeft()
  if markWinRightTop ~= nil and #markWinRightTop ~= 0 then
    textTurn.text = "Won: " .. markWinRightTop[1].mark
    DrawTheLine(markWinRightTop)
    run = false
    return true
  end

  if Board:IsAllMarksSet() then
    textTurn.text = ("Draw")
    run = false
    return true
  end

  textTurn.text = ("Turn: " .. turn)
  return true
end

Board:CreateBoard(elementsGroup, tapEvent)
