-- ---------------
-- Game.lua
-- ---------------

local composer = require( "composer" )
local widget = require( "widget" )
local loadsave = require ( "loadsave" )

local scene = composer.newScene()

local EMPTY, X, O = 0, 1, 2
local whichTurn = X
local gameOver = false
local resetButton, computerFirst, computerSecond, goesFirst, turnText, turnText2, undoButton
local winText, loseText, drawText, clearScoreButton
local previousGameButton
local firstMoveGroup = display.newGroup()
local winnerTurnforMessage = 1
local previousGameRecord = {}
local computersTurn = false

function chooseTurn(group)
    local backgroundImage = display.newImageRect("mainbackground.jpg", 520, 680)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY
    firstMoveGroup:insert(backgroundImage)

    turnText = display.newText("Choose a side", display.contentCenterX, 10, native.systemFont, 40)
    firstMoveGroup:insert(turnText)
    turnText2 = display.newText("(X goes first)", display.contentCenterX, 60, native.systemFont, 20)
    firstMoveGroup:insert(turnText2)

    computerFirst = widget.newButton(
        {
            id = 1,
            label = "X",
            onEvent = removeBackground,
            emboss = false,
            shape = "roundedRect",
            width = 90,
            height = 150,
            cornerRadius = 10,
            fillColor = {default={0,0,0,0}, over={1,1,1,1}},
            labelColor = {default={1,1,1}, over={1,1,1,1}},
            fontSize = 50
        }
    )
    computerFirst.x = display.contentCenterX - 50
    computerFirst.y = 200
    firstMoveGroup:insert(computerFirst)

    computerSecond = widget.newButton(
        {
            id = 2,
            label = "O",
            onEvent = removeBackground,
            emboss = false,
            shape = "roundedRect",
            width = 90,
            height = 150,
            cornerRadius = 10,
            fillColor = {default={0,0,0,0}, over={1,1,1,1}},
            labelColor = {default={1,1,1}, over={1,1,1,1}},
            fontSize = 50
        }
    )
    computerSecond.x = display.contentCenterX + 50
    computerSecond.y = 200
    firstMoveGroup:insert(computerSecond)

end

function makeGridFirst(group)
    local backgroundImage = display.newImageRect("mainbackground.jpg", 520, 680)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY

    local diffText = display.newText(difficulty .. " mode", display.contentCenterX, 0, native.systemFont, 30)

    local gameHistory = loadsave.loadTable("settings.json")
    if gameHistory == nil then
        gameHistory = {
            win = 0,
            lose = 0,
            draw = 0
        }
    end

    loadsave.saveTable(gameHistory, "settings.json")

    winText = display.newText("Win = " .. gameHistory.win, 70, display.contentHeight - 60, native.systemFont, 20)
    loseText = display.newText("Lose = " .. gameHistory.lose, display.contentCenterX, display.contentHeight - 60, native.systemFont, 20)
    drawText = display.newText("Draw = " .. gameHistory.draw, display.contentWidth - 70, display.contentHeight - 60, native.systemFont, 20)

    makeGrid(group)
end

function makeGrid(group)
    local d = display
    local w20 = d.contentWidth * .2
    local h20 = d.contentHeight * .2
    local w40 = d.contentWidth * .4
    local h40 = d.contentHeight * .4
    local w60 = d.contentWidth * .6
    local h60 = d.contentHeight * .6
    local w80 = d.contentWidth * .8
    local h80 = d.contentHeight * .8

    ----DRAW LINES FOR BOARD
    local lline = d.newLine(w40,h20,w40,h80 )
    lline.strokeWidth = 5
    local rline = d.newLine(w60,h20,w60,h80 )
    rline.strokeWidth = 5
    local bline = d.newLine(w20,h40,w80,h40 )
    bline.strokeWidth = 5
    local tline = d.newLine(w20,h60,w80,h60 )
    tline.strokeWidth = 5

    --PLACE BOARD COMPARTMENT DIMENSIONS IN TABLE
    board ={
        {"tl", 1, w20, h40, w40, h20,0},
        {"tm",2, w40,h40,w60,h20,0},
        {"tr",3, w60,h40,w80,h20,0},
        {"ml", 4, w20, h60, w40, h40,0},
        {"mm",5, w40,h60,w60,h40,0},
        {"mr",6, w60,h60,w80,h40,0},
        {"bl", 7, w20, h80, w40, h60,0},
        {"bm",8, w40,h80,w60,h60,0},
        {"br",9, w60,h80,w80,h60,0}
    }

    if goesFirst == 1 then
        turnMessage = display.newText("Your Turn", 10, 60, native.systemFont, 20)
    else
        turnMessage = display.newText("Computer's Turn", 10, 60, native.systemFont, 20)
    end
    turnMessage.anchorX = 0
    turnMessage.anchorY = 0

    marks = {}
    gameTurns = {}

    resetButton = widget.newButton(
        {
            id = "reset",
            label = "Reset",
            onEvent = resetGame,
            emboss = false,
            shape = "roundedRect",
            width = 60,
            height = 20,
            cornerRadius = 10,
            fillColor = {default={0,0,0,0}, over={1,1,1,1}},
            labelColor = {default={1,1,1}, over={1,1,1,1}}
        }
    )
    resetButton.x = display.contentWidth - 70
    resetButton.y = display.contentHeight + 30

    undoButton = widget.newButton(
        {
            id = "undo",
            label = "Undo",
            onEvent = undoMove,
            emboss = false,
            shape = "roundedRect",
            width = 60,
            height = 20,
            cornerRadius = 10,
            fillColor = {default={0,0,0,0}, over={1,1,1,1}},
            labelColor = {default={1,1,1}, over={1,1,1,1}}
        }
    )
    undoButton.x = display.contentWidth - 70
    undoButton.y = display.contentHeight - 10

    clearScoreButton = widget.newButton(
        {
            label = "Clear Score",
            onEvent = clearScore,
            emboss = false,
            shape = "roundedRect",
            width = 90,
            height = 25,
            cornerRadius = 10,
            fillColor = {default={0,0,0,0}, over={1,1,1,1}},
            labelColor = {default={1,1,1}, over={1,1,1,1}}
        }
    )
    clearScoreButton.x = 70
    clearScoreButton.y = display.contentHeight - 10

    previousGameButton = widget.newButton(
        {
            label = "Replay\nPrevious\nGame",
            onEvent = previousGame,
            emboss = false,
            shape = "roundedRect",
            width = 70,
            height = 60,
            cornerRadius = 10,
            fillColor = {default={0,0,0,0}, over={1,1,1,1}},
            labelColor = {default={1,1,1}, over={1,1,1,1}}
        }
    )
    previousGameButton.x = display.contentCenterX + 5
    previousGameButton.y = display.contentHeight
end

function removeBackground(event)
    if event.phase == "ended" then
        goesFirst = event.target.id
        firstMoveGroup:removeSelf()
        firstMoveGroup = nil
        makeGridFirst(sceneGroup)
        if goesFirst == 2 then
            winnerTurnforMessage = 2
            computersTurn = true
            computerMove()
        end
    end
end

--Check empty compartments
local function checkEmpty(move)
    if board[move][7] == EMPTY then
        return move
    else
        return 0
    end
end

--Generate random number
local function randomNumber()
    local availableCells = {}
    for t = 1, 9 do
        local cell = board[t]
        if cell[7] == 0 then
            table.insert(availableCells, cell)
        end
    end
    local randomChoice = math.random(1, #availableCells)
    local move = availableCells[randomChoice]
    return move[2]
end

local function checkWinner()
    local function checkLine(a, b, c)
        return board[a][7] ~= EMPTY and board[a][7] == board[b][7] and board[a][7] == board[c][7]
    end

    --Rows
    for i=1, 3 do
        if checkLine((i-1)*3 + 1, (i-1)*3 + 2, (i-1)*3 + 3) then
                winMessage(board[(i-1)*3 + 1][7])
            return
        end
    end

    --Column
    for i=1, 3 do
        if checkLine(i, i+3, i+6) then
            winMessage(board[i][7])
            return
        end
    end

    --Diagonal
    for i=1, 3 do
        if checkLine(1, 5, 9) or checkLine(3, 5, 7) then
            winMessage(board[5][7])
            return
        end
    end

    --Draw
    local draw = true
    for i = 1, 9 do
        if board[i][7] == EMPTY then
            draw = false
        end
    end

    if draw == true then
        winMessage(3)
    end
end

function winMessage(winner)
    local gameHistory = loadsave.loadTable("settings.json")

    if winner == 1 and winnerTurnforMessage == 1 then
        turnMessage.text = "You Win!"
        gameHistory.win = gameHistory.win + 1
        table.insert(previousGameRecord, 1)
    elseif winner == 1 and winnerTurnforMessage == 2 then
        turnMessage.text = "Computer Wins!"
        gameHistory.lose = gameHistory.lose + 1
        table.insert(previousGameRecord, 2)
    elseif winner == 2 and winnerTurnforMessage == 1 then
        turnMessage.text = "Computer Wins!"
        gameHistory.lose = gameHistory.lose + 1
        table.insert(previousGameRecord, 2)
    elseif winner == 2 and winnerTurnforMessage == 2 then
        turnMessage.text = "You Win!"
        table.insert(previousGameRecord, 1)
        gameHistory.win = gameHistory.win + 1
    elseif winner == 3 then
        turnMessage.text = "Draw!"
        gameHistory.draw = gameHistory.draw + 1
        table.insert(previousGameRecord, 3)
    end
    loadsave.saveTable(gameHistory, "settings.json")

    winText.text = "Win = " .. gameHistory.win
    loseText.text = "Lose = " .. gameHistory.lose
    drawText.text = "Draw = " .. gameHistory.draw

    table.insert(previousGameRecord, winnerTurnforMessage)

    for i=1, #gameTurns do
        table.insert(previousGameRecord, gameTurns[i])
    end

    gameOver = true
end

--Computer Easy mode
function computerMoveEasy()
    local move = randomNumber()
    board[move][7] = whichTurn
    if whichTurn == O then
        r = display.newText("O", board[move][3] + 10, board[move][6] + 10, "Arial", 64)
        print("O has been placed by Computer in board " .. board[move][2] .. " or " .. board[move][1])
    else
        r = display.newText("X", board[move][3] + 10, board[move][6] + 10, "Arial", 64)
        print("X has been placed by Computer in board " .. board[move][2] .. " or " .. board[move][1])
    end

    table.insert(marks, r)
    table.insert(gameTurns, move)
    r.anchorX = 0
    r.anchorY = 0

    whichTurn = whichTurn == X and O or X
    turnMessage.text = "Your Turn"
    computersTurn = false
    checkWinner()
end

function hardLogic(board)

    local board = board

    local function hardCheckLine(a, b, c, marker)
        if board[a][7] == marker and board[b][7] == marker and board[c][7] == EMPTY then
            return c
        end
        if board[b][7] == marker and board[c][7] == marker and board[a][7] == EMPTY then
            return a
        end
        if board[a][7] == marker and board[c][7] == marker and board[b][7] == EMPTY then
            return b
        end
    end

    local move

    --Two in a row
    for i = 1, 3 do
        --Row
        move = hardCheckLine((i-1)*3 + 1, (i-1)*3 + 2, (i-1)*3 + 3, O)
        if move then
            return move
        end
        move = hardCheckLine((i-1)*3 + 1, (i-1)*3 + 2, (i-1)*3 + 3, X)
        if move then
            return move
        end

        --Column
        move = hardCheckLine(i, i+3, i+6, O)
        if move then
            return move
        end

        move = hardCheckLine(i, i+3, i+6, X)
        if move then
            return move
        end

        --Diagonal
        move = hardCheckLine(1, 5, 9, O)
        if move then
            return move
        end

        move = hardCheckLine(3, 5, 7, O)
        if move then
            return move
        end

        move = hardCheckLine(1, 5, 9, X)
        if move then
            return move
        end

        move = hardCheckLine(3, 5, 7, X)
        if move then
            return move
        end
    end

    --Two Lines of two in a row
    if board[1][7] == X and board[9][7] == X then
        return 2
    end

    if board[3][7] == X and board[7][7] == X then
        return 2
    end

    move = hardCheckLine(2, 4, 1, O)
    if move then
        return move
    end

    move = hardCheckLine(2, 4, 1, X)
    if move then
        return move
    end

    move = hardCheckLine(2, 6, 3, O)
    if move then
        return move
    end

    move = hardCheckLine(2, 6, 3, X)
    if move then
        return move
    end

    move = hardCheckLine(4, 8, 7, O)
    if move then
        return move
    end

    move = hardCheckLine(4, 8, 7, X)
    if move then
        return move
    end

    move = hardCheckLine(6, 8, 9, O)
    if move then
        return move
    end

    move = hardCheckLine(6, 8, 9, X)
    if move then
        return move
    end

    --Centre is Free
    if board[5][7] == EMPTY then
        return 5
    end

    --Opponent played in a corner, play the opposite corner
    local length = #gameTurns
    local lastMark = gameTurns[length]

    if lastMark == 1 and board[9][7] == EMPTY then
        return 9
    elseif lastMark == 3 and board[7][7] == EMPTY then
        return 7
    elseif lastMark == 7 and board[3][7] == EMPTY then
        return 3
    elseif lastMark == 9 and board[1][7] == EMPTY then
        return 1
    end

    --Free corner
    if board[1][7] == EMPTY then
        return 1
    elseif board[3][7] == EMPTY then
        return 3
    elseif board[7][7] == EMPTY then
        return 7
    elseif board[9][7] == EMPTY then
        return 9
    end

    --Random Number
    local randomMove = randomNumber()

    return randomMove
end

--Computer Hard Mode
function computerMoveHard()
    local move = hardLogic(board)
    board[move][7] = whichTurn

    if whichTurn == O then
        r = display.newText("O", board[move][3] + 10, board[move][6] + 10, "Arial", 64)
        print("O Has been placed by Computer in board " .. board[move][2] .. " or " .. board[move][1])
    else
        r = display.newText("X", board[move][3] + 10, board[move][6] + 10, "Arial", 64)
        print("X Has been placed by Computer in board " .. board[move][2] .. " or " .. board[move][1])
    end

    table.insert(marks, r)
    table.insert(gameTurns, move)
    r.anchorX = 0
    r.anchorY = 0
    whichTurn = whichTurn == X and O or X
    turnMessage.text = "Your Turn"
    computersTurn = false

    checkWinner()
end

function computerMove()
    if gameOver == false then
        computersTurn = true
        turnMessage.text = "Computer's Turn"
        if difficulty == "Easy" then
            timer.performWithDelay(1500, computerMoveEasy)
        elseif difficulty == "Hard" then
            timer.performWithDelay(1500, computerMoveHard)
        end
    end
end

--Fill Compartment with X when touched
local function fill (event)
if event.phase == "began" and gameOver == false and computersTurn == false then
    for t = 1, 9 do
        if event.x > board[t][3] and event.x < board [t][5] then
        if event.y < board[t][4] and event.y > board[t][6] then
        if board[t][7] == EMPTY then
            board[t][7] = whichTurn
            if whichTurn == X then
                r = display.newText("X", board[t][3] + 10, board[t][6] + 10, "Arial", 64)
                print("X has been placed by Human in board " .. board[t][2] .. " or " .. board[t][1])
            else
                r = display.newText("O", board[t][3] + 10, board[t][6] + 10, "Arial", 64)
                print("O has been placed by Human in board " .. board[t][2] .. " or " .. board[t][1])
            end

            table.insert(marks, r)
            table.insert(gameTurns, t)
            r.anchorX = 0
            r.anchorY = 0

            whichTurn = whichTurn == X and O or X
            checkWinner()
            computerMove()
        end
        end
        end
    end
end
end

function clearScore(event)
    if ("ended" == event.phase) then
        local gameHistory = loadsave.loadTable("settings.json")

        gameHistory.win = 0
        gameHistory.lose = 0
        gameHistory.draw = 0

        loadsave.saveTable(gameHistory, "settings.json")

        winText.text = "Win = " .. gameHistory.win
        loseText.text = "Lose = " .. gameHistory.lose
        drawText.text = "Draw = " .. gameHistory.draw
    end
end

function resetGame(event)
    if ("ended" == event.phase) then
        print("")

        gameOver = false
        turnMessage:removeSelf()

        for i=1, 9 do
            board[i][7] = EMPTY
        end

        for i=1, #marks do
            marks[i]:removeSelf()
            marks[i] = nil
        end

        whichTurn = X

        marks = {}
        gameTurns = {}
        makeGrid(group)

        if goesFirst == 2 then
            winnerTurnforMessage = 2
            computerMove()
        end
    end
end

function undoMove(event)
    if("ended" == event.phase) then
        if #gameTurns > 1 and gameOver == false then

            for i=1, 2 do
                board[gameTurns[#gameTurns]][7] = EMPTY
                marks[#marks]:removeSelf()
                marks[#marks] = nil
                table.remove(gameTurns)
            end

            return
        else
            return
        end
    end
end

function previousGame(event)
    local function printMarks(turn, turnLogo, boardNumber, number)
        if turn == 1 then
            turnMessage.text = "Your Turn"
        elseif turn == 2 then
            turnMessage.text = "Computer's Turn"
        end
        
        if turnLogo == X then
            r = display.newText("X", board[boardNumber][3] + 10, board[boardNumber][6] + 10, "Arial", 64)
        elseif turnLogo == O then
            r = display.newText("O", board[boardNumber][3] + 10, board[boardNumber][6] + 10, "Arial", 64)
        end
        table.insert(marks, r)
        r.anchorX = 0
        r.anchorY = 0

        if number == #previousGameRecord-2 then
            if previousGameRecord[1] == 1 then
                turnMessage.text = "You Win!"
            elseif previousGameRecord[1] == 2 then
                turnMessage.text = "Computer Wins!"
            elseif previousGameRecord[1] == 3 then
                turnMessage.text = "Draw!"
            end
        end
    end

    if("ended" == event.phase) then
        if #previousGameRecord == 0 then
            return
        else
            local turn
            local turnLogo = O

            for i=1, #marks do
                marks[i]:removeSelf()
                marks[i] = nil
            end

            if previousGameRecord[2] == 1 then
                turn = 1
                turnMessage.text = "Your Turn"
            else
                turn = 2
                turnMessage.text = "Computer's Turn"
            end

            local number = 1
            
            local myClosure = function()
                local boardPrint = previousGameRecord[number + 2]
                turnLogo = turnLogo == O and X or O
                turn = turn == 2 and 1 or 2
                printMarks(turn, turnLogo, boardPrint, number)
                number = number + 1
            end

            timer.performWithDelay(2000, myClosure, #previousGameRecord-2)
        end
    end
end

Runtime:addEventListener("touch", fill)

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    local sceneGroup = self.view
    difficulty = event.params.difficulty
    chooseTurn(sceneGroup)
end

-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end

-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        
    end
end

-- destroy()
function scene:destroy(event)
    resetGame()
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