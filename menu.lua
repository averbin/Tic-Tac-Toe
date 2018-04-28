-------------------------------------------------------------------------------
--
--
-- Tic-Tac-Toy menu.
--
--
-------------------------------------------------------------------------------
local composer = require( "composer" )

local scene = composer.newScene()

local function gotoGame()
	composer.removeScene("game")
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

function scene:create( event )
  local sceneGroup = self.view
  local playButton = display.newText(sceneGroup, "Play", display.contentCenterX, display.contentCenterY, native.systemFont, 44)
	playButton:setFillColor(0.82, 0.86, 1)
  playButton:addEventListener("tap", gotoGame)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
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
