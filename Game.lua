-- -----------------------------------------------------------------------------------
--
-- Tic-Tac-Toy game the main part of the code.
--
-- -----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Board = require "Board"
local BoardElement = require "BoardElement"
local itemsInterface = require "ItemInterface"
local elementsGroup = display.newGroup()
local itemsGroup = display.newGroup()
local run = true
local turn = "x" -- could be "x" or "o"
local exitButton = nil
local textTurn = nil
local linesSound = nil
local circleSound = nil

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function RetryTapEvent( event )
  itemsInterface:RemoveAllItems()
  Board:CleanBoard()
  --turn = "x"
  run = true
  textTurn.text = "Turn: "  .. turn
  --os.exit()
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
      itemsInterface:DrawEx(itemsGroup, event.target.x, event.target.y)
      audio.play(linesSound)
      turn = "o"
    else
      boardElement.mark = "o"
      itemsInterface:DrawCircle(itemsGroup, event.target.x, event.target.y)
      audio.play(circleSound)
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

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view

    exitButton = display.newRect(
      sceneGroup,
      display.contentWidth - display.contentWidth / 2,
      display.contentHeight - 50, 30, 30)
    exitButton:setFillColor(1.0, 0.0, 0.0)
    exitButton:addEventListener("tap", RetryTapEvent)

    textTurn = display.newText(sceneGroup,
      "Turn: " .. turn,
       display.contentWidth / 2,
       90,
       native.systemFont, 18)
    textTurn:setFillColor(255, 239, 0)

    linesSound = audio.loadSound("res/audio/lines_sound(pencil).mp3")
    circleSound = audio.loadSound("res/audio/circle_sound(pencil).mp3")
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
      Board:CreateBoard(elementsGroup, tapEvent)
      Board:SetTransaction()
        -- Code here runs when the scene is entirely on screen
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    audio.dispose( linesSound )
    audio.dispose( circleSound )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
