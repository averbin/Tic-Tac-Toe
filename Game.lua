-- -----------------------------------------------------------------------------------
--
-- Tic-Tac-Toy game the main part of the code.
--
-- -----------------------------------------------------------------------------------

-- requirements
local Board = require "Board"
local BoardElement = require "BoardElement"
local composer = require "composer"
local gameData = require "GameData"
local itemsInterface = require "ItemInterface"
local widget = require "widget"
local basicAI = require "BasicAI"
--
local scene = composer.newScene()
local elementsGroup = display.newGroup()
local itemsGroup = display.newGroup()
local retryButton = nil
local textTurn = nil
local firstPlayerText = nil
local firstPlayerCounter = 0
local secondPlayerText = nil
local secondPlayerCounter = 0
local linesSound = nil
local circleSound = nil
local wonSound = nil
local drawSound = nil
local menuButton = nil
local soundImage = nil

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function SetElementToBoard(boardElement)
  if boardElement ~= nil and boardElement.mark == "" then
    if gameData.turn == "x" then
      boardElement.mark = "x"
      itemsInterface:DrawEx(itemsGroup, boardElement.element.x, boardElement.element.y)
      audio.play(linesSound)
      gameData.turn = "o"
    else
      boardElement.mark = "o"
      itemsInterface:DrawCircle(itemsGroup, boardElement.element.x, boardElement.element.y)
      audio.play(circleSound)
      gameData.turn = "x"
    end
    return true
  else
    return false
  end
end

local function SetUpTexts()
  firstPlayerText.text = "Player1 (" .. gameData.firstPlayer .. "): " .. tostring(firstPlayerCounter)
  local whoPlayText = ""
  if gameData.isSingle == true then
    whoPlayText = "Computer ("
  else
    whoPlayText = "Player2 ("
  end
  secondPlayerText.text = whoPlayText .. gameData.secondPlayer .. "): " .. tostring(secondPlayerCounter)
end

local function SetupCounter(boardElement)
  if boardElement ~= nil and boardElement.mark == gameData.firstPlayer then
    firstPlayerCounter = firstPlayerCounter + 1
  else
    secondPlayerCounter = secondPlayerCounter + 1
  end

  if firstPlayerCounter > 99 or secondPlayerCounter > 99 then
    firstPlayerCounter = 0
    secondPlayerCounter = 0
  end

  SetUpTexts()
end

local function CheckMarksIndividual( boardElements )
  if boardElements ~= nil and #boardElements ~= 0 and #boardElements == #Board  then
    textTurn.text = "Won: " .. boardElements[1].mark
    gameData.turn = boardElements[1].mark
    itemsInterface:DrawTheLine(itemsGroup, boardElements)
    gameData.run = false
    SetupCounter(boardElements[1])
    audio.play(wonSound)
    return true
  end
  return false
end

local function CheckAllMarksOnBoard()

  if CheckMarksIndividual(Board:FindByHorizontal(#Board)) then return true end
  if CheckMarksIndividual(Board:FindByVertical(#Board)) then return true end
  if CheckMarksIndividual(Board:FindFromLeftToptoRightBottom(#Board)) then return true end
  if CheckMarksIndividual(Board:FindFromRightToptoBottomLeft(#Board)) then return true end

  if Board:IsAllMarksSet() then
    textTurn.text = ("Draw")
    gameData.run = false
    audio.play( drawSound )
    return true
  end

  return false
end

local function RetryTapEvent( event )
  itemsInterface:RemoveAllItems()
  Board:CleanBoard()
  --turn = "x"
  gameData.run = true
  textTurn.text = "Turn: "  .. gameData.turn
end

local function tapEvent( event )
  if gameData.run == false then
    return true
  end

  if gameData.isSingle and gameData.firstPlayer ~= gameData.turn then
    return true
  end

  boardElement = Board:FindElement(event.target.name)
  SetElementToBoard(boardElement)

  textTurn.text = ("Turn: " .. gameData.turn)
  local isWon = CheckAllMarksOnBoard()
  if isWon == false and basicAI.isSinglePlayer == true then
    basicAI.isTurn = true
  end

  if Board:IsAllMarksSetOnRow(1) then
    print("We have set row 1")
  end

  if Board:IsAllMarksSetOnColumn(1) then
    print("We have set column 1")
  end

  return true
end

local function SwapImage(oldImage, pathToImage)
  if oldImage ~= nil then
    local currentImage = display.newImageRect(
      oldImage.parent,
      pathToImage, oldImage.width, oldImage.height)
      currentImage.x = oldImage.x
      currentImage.y = oldImage.y
      oldImage:removeSelf()
      return currentImage
  end
end

local function TurnOnOffSound()
  if gameData.turnOnSound then
    gameData.turnOnSound = false
    audio.setVolume(0.0)
    soundImage = SwapImage(soundImage, "res/img/turnOffSound.png")
  else
    gameData.turnOnSound = true
    audio.setVolume(1)
    soundImage = SwapImage(soundImage, "res/img/turnOnSound.png")
  end
  soundImage:addEventListener("tap", TurnOnOffSound)
end

local function GoBackToMenu(event)
  if ( "ended" == event.phase ) then
    composer.removeScene("menu")
    composer.gotoScene("menu", { time=800, effect="crossFade"})
  end
end

local function ComputerStep()
  if gameData.run == true and gameData.turn == gameData.secondPlayer then
    print("Computer Step")
    local element = basicAI:ComputerStep()
    SetElementToBoard(element)
    textTurn.text = "Turn: "  .. gameData.turn
    CheckAllMarksOnBoard()
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view

    retryButton = display.newRect(
      sceneGroup,
      display.contentWidth - display.contentWidth / 2,
      display.contentHeight - 50, 30, 30)
    retryButton:setFillColor(1.0, 0.0, 0.0)
    retryButton:addEventListener("tap", RetryTapEvent)

    menuButton = widget.newButton(
    {
        width = 30,
        height = 30,
        defaultFile = "res/img/backToMenu.png",
        overFile = "res/img/backToMenu_selected.png",
        onEvent = GoBackToMenu
    })

    menuButton.x = display.contentWidth - 50
    menuButton.y = 30

    soundImage = display.newImageRect( sceneGroup, "res/img/turnOnSound.png", 30, 30)
    soundImage.x = menuButton.x - soundImage.width - 10
    soundImage.y = menuButton.y
    soundImage:addEventListener("tap", TurnOnOffSound)
    TurnOnOffSound()

    textTurn = display.newText(sceneGroup,
      "Turn: " .. gameData.turn,
       display.contentWidth / 2,
       90,
       native.systemFont, 18)
    textTurn:setFillColor(255, 239, 0)

    firstPlayerText = display.newText( sceneGroup,
    "",
    textTurn.x - 80, textTurn.y, native.systemFont, 12)
    firstPlayerText:setFillColor(255, 239, 0)

    secondPlayerText = display.newText( sceneGroup,
    "",
    display.contentWidth - 70, textTurn.y, native.systemFont, 12)
    secondPlayerText:setFillColor(255, 239, 0)
    SetUpTexts()

    linesSound = audio.loadSound("res/audio/lines_sound(pencil).mp3")
    circleSound = audio.loadSound("res/audio/circle_sound(pencil).mp3")
    wonSound = audio.loadSound("res/audio/boxing_bell.mp3")
    drawSound = audio.loadSound("res/audio/applause8.mp3")

    basicAI.markUsesByAI = gameData.secondPlayer
    basicAI.isSinglePlayer = gameData.isSingle
    basicAI.isTurn = false
    if basicAI.isSinglePlayer == true then
      gameLoopTimer = timer.performWithDelay( 1000, ComputerStep, 0 )
    end
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
        --timer.cancel( gameLoop )
        firstPlayerCounter = 0
        secondPlayerCounter = 0
        itemsInterface:RemoveAllItems()
        Board:CleanBoard()
        Board:DeleteElements()
        menuButton:removeSelf()
        soundImage:removeSelf()
        retryButton:removeSelf()
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
    audio.dispose( wonSound )
    audio.dispose( drawSound)
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
