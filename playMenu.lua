-- -----------------------------------------------------------------------------------
--
-- Play menu for Tic-Tac-Toy game, where you can choose one player or two.
--
-- -----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local backToMenuText = nil
local singlePlayerButton = nil
local twoPlayersButton = nil

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function GoBackToMenu()
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=800, effect="crossFade"})
  backToMenuText:setFillColor(1, 1, 1)
end

function GoOnePlayerMode( event )
  if ( "ended" == event.phase ) then
    composer.removeScene("game")
    composer.gotoScene("game", { time=800, effect="crossFade"})
  end
end

function GoTwoPlayersMode(event)
  if ( "ended" == event.phase ) then
    composer.removeScene("game")
    composer.gotoScene("game", { time=800, effect="crossFade"})
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    backToMenuText = display.newText(sceneGroup, "Back",
      display.contentCenterX,
      display.contentCenterY + 70, native.systemFont, 30)
    backToMenuText:setFillColor(255, 239, 0)

    twoPlayersButton = widget.newButton(
    {
        width = 300,
        height = 50,
        defaultFile = "res/img/TwoPlayers.png",
        overFile = "res/img/TwoPlayers_selected.png",
        onEvent = GoTwoPlayersMode
    })

    twoPlayersButton.x = display.contentCenterX
    twoPlayersButton.y = backToMenuText.y - 50

    singlePlayerButton = widget.newButton(
    {
        width = 300,
        height = 50,
        defaultFile = "res/img/SinglePlayer.png",
        overFile = "res/img/SinglePlayer_selected.png",
        onEvent = GoOnePlayerMode
    })

    singlePlayerButton.x = display.contentCenterX
    singlePlayerButton.y = twoPlayersButton.y - 70

    backToMenuText:addEventListener("tap", GoBackToMenu)
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        singlePlayerButton:removeSelf()
        twoPlayersButton:removeSelf()
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end


-- destroy()
function scene:destroy( event )
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
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
