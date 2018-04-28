-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local Board = require "Board"
local BoardElement = require "BoardElement"
local itemsInterface = require "ItemInterface"
local elementsGroup = display.newGroup()
local itemsGroup = display.newGroup()
local uiGroup = display.newGroup()
local run = true
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
  itemsInterface:RemoveAllItems()
  Board:CleanBoard()
  turn = "x"
  run = true
  textTurn.text = "Turn: "  .. turn
  --os.exit()
end
exitButton:addEventListener("tap", RetryTapEvent)

function tapEvent( event )
  if run == false then
    return true
  end

  boardElement = Board:FindElement(event.target.name)
  if boardElement.mark == "" then
    print("Turn: " .. turn)
    if turn == "x" then
      boardElement.mark = "x"
      itemsInterface:DrawEx(itemsGroup, event.target.x, event.target.y)
      turn = "o"
    else
      boardElement.mark = "o"
      itemsInterface:DrawCircle(itemsGroup, event.target.x, event.target.y)
      turn = "x"
    end
  else
    print("Exists: ".. event.target.name .. "\t" .. boardElement.mark)
  end

  local markWinRow = Board:FindByHorizontal()
  if markWinRow ~= nil and markWinRow ~= 0 then
    textTurn.text = "Won: " .. markWinRow[1].mark
    itemsInterface:DrawTheLine(itemsGroup, markWinRow)
    run = false
    return true
  end

  local markWinColumn = Board:FindByVertical()
  if markWinColumn ~= nil and #markWinColumn ~= 0 then
    textTurn.text = "Won: " .. markWinColumn[1].mark
    itemsInterface:DrawTheLine(itemsGroup, markWinColumn)
    run = false
    return true
  end

  local markWinLeftTop = Board:FindFromLeftToptoRightBottom()
  if markWinLeftTop ~= nil and #markWinLeftTop ~= 0 then
    textTurn.text = "Won: " .. markWinLeftTop[1].mark
    itemsInterface:DrawTheLine(itemsGroup, markWinLeftTop)
    run = false
    return true
  end

  local markWinRightTop = Board:FindFromRightToptoBottomLeft()
  if markWinRightTop ~= nil and #markWinRightTop ~= 0 then
    textTurn.text = "Won: " .. markWinRightTop[1].mark
    itemsInterface:DrawTheLine(itemsGroup, markWinRightTop)
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
