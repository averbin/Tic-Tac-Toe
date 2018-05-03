-- -----------------------------------------------------------------------------------
--
-- Play menu for Tic-Tac-Toy game, where you can choose one player or two.
--
-- -----------------------------------------------------------------------------------


local composer = require( "composer" )

local scene = composer.newScene()

local backToMenuText = nil
local onePlayerText = nil
local twoPlayersText = nil

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function GoBackToMenu()
  composer.removeScene("menu")
  composer.gotoScene("menu", { time=800, effect="crossFade"})
  backToMenuText:setFillColor(1, 1, 1)
end

function GoOnePlayerMode()
  composer.removeScene("game")
  composer.gotoScene("game", { time=800, effect="crossFade"})
  onePlayerText:setFillColor(1, 1, 1)
end

function GoTwoPlayersMode()
  composer.removeScene("game")
  composer.gotoScene("game", { time=800, effect="crossFade"})
  twoPlayersText:setFillColor(1, 1, 1)
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

    twoPlayersText = display.newText(sceneGroup, "Two Players",
      display.contentCenterX,
      backToMenuText.y - 50, native.systemFont, 30)
    twoPlayersText:setFillColor(255, 239, 0)

    onePlayerText = display.newText(sceneGroup, "One Player",
      display.contentCenterX,
      twoPlayersText.y - 50, native.systemFont, 30)
    onePlayerText:setFillColor(255, 239, 0)

    backToMenuText:addEventListener("tap", GoBackToMenu)
    twoPlayersText:addEventListener("tap", GoTwoPlayersMode)
    onePlayerText:addEventListener("tap", GoOnePlayerMode)
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
