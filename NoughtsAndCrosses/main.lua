-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require("widget")

require("lunatest")
require("tests.Mytests")

local backgroundImage = display.newImageRect("mainbackground.jpg", 520, 680)
backgroundImage.x = display.contentCenterX
backgroundImage.y = display.contentCenterY

local function cleanUp()
    welcomeText:removeSelf()
    welcomeText = nil
    text:removeSelf()
    text = nil
    easyButton:removeSelf()
    easyButton = nil
    hardButton:removeSelf()
    hardButton = nil
    backgroundImage:removeSelf()
    backgroundImage = nil
end

local function gameMode( event )

    if event.phase == "ended" then
        local params = {difficulty = event.target.id}
        cleanUp()
        composer.gotoScene("Game", {params = params})
    end
end

welcomeText = display.newText("Welcome to Tic Tac Toe", display.contentCenterX, 0, native.systemFont, 25)
text = display.newText("Choose your difficulty!", display.contentCenterX, display.contentCenterY, native.systemFont, 20)

easyButton = widget.newButton(
    {
        id = "Easy",
        label = "Easy Mode",
        onEvent = gameMode,
        emboss = false,
        shape = "roundedRect",
        width = 150,
        height = 50,
        cornerRadius = 10,
        fillColor = {default={0,0,1}, over={1,1,1,1}},
        labelColor = {default={1,1,1}, over={1,1,1,1}}
    }
)

easyButton.x = display.contentCenterX
easyButton.y = display.contentCenterY + 70

hardButton = widget.newButton(
    {
        id = "Hard",
        label = "Hard Mode",
        onEvent = gameMode,
        emboss = false,
        shape = "roundedRect",
        width = 150,
        height = 50,
        cornerRadius = 10,
        fillColor = {default={0,0,1}, over={1,1,1,1}},
        labelColor = {default={1,1,1}, over={1,1,1,1}}
    }
)

hardButton.x = display.contentCenterX
hardButton.y = display.contentCenterY + 150