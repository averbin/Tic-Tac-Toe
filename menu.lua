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

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function GotoPlayScene( event )
  --if event.phase == "will" then
    playText:setFillColor(1.0, 1.0, 1.0)
  --elseif event.phase == "did" then
    composer.removeScene( "playMenu")
    composer.gotoScene( "playMenu", { time=800, effect="crossFade" })
  --end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
    local sceneGroup = self.view
    title = display.newImageRect(sceneGroup, "res/img/title.png", 300, 100)
    title.x = display.contentCenterX
    playText = display.newText(sceneGroup, "Play",
    display.contentCenterX,
    display.contentCenterY + 70, native.systemFont, 30)
    playText:setFillColor(255, 239, 0)
    playText:addEventListener("tap", GotoPlayScene)
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        transition.to( title, { time = 1000, y = title.y + 100, transition=easing.outBounce } )
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
