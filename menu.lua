-------------------------------------------------------------------------------
--
--
-- Tic-Tac-Toy menu.
--
--
-------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- New Scene
-- -----------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local title = nil
local playText = nil
local gameLoopTimer = nil
local creatorText = nil
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function VisualEffectForText( event )
  if playText ~= nil and playText.alpha >= 1 then
    playText.alpha = 0
  else
    playText.alpha = playText.alpha + 0.03
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    title = display.newImageRect(sceneGroup, "res/img/title.png", 300, 100)
    title.x = display.contentCenterX
    playText = display.newText(sceneGroup, "Touch any where to play",
    display.contentCenterX,
    display.contentCenterY + 80, native.systemFont, 20)
    playText:setFillColor(255, 239, 0)

    local function gotoPlayMode( event )
        playText:setFillColor(1.0, 1.0, 1.0)
        composer.removeScene( "playMode")
        composer.gotoScene( "playMode", { time=800, effect="crossFade" })
    end
    sceneGroup:addEventListener("tap", gotoPlayMode)

    creatorText = display.newText(sceneGroup, "Made by ArticSnake",
      display.contentCenterX,
      display.contentHeight - 10, native.systemFont, 12)
    creatorText:setFillColor(255, 239, 0)
end

-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        transition.to( title, { time = 1000, y = display.contentCenterY, transition=easing.outBounce } )
        gameLoopTimer = timer.performWithDelay( 60, VisualEffectForText, 0)
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
        timer.cancel( gameLoopTimer )
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
