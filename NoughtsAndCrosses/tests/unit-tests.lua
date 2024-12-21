-- ---------------
-- unit-tests.lua
-- ---------------

module(..., package.seeall)

require "Game"

function testFirstCondition()
    --Diagonally two in a row, so computer plays the remaining square (bottom right)
    local board ={
        {"tl", 1, w20, h40, w40, h20, 1}, {"tm", 2, w40, h40, w60, h20, 0}, {"tr", 3, w60, h40, w80, h20, 0},
        {"ml", 4, w20, h60, w40, h40, 2}, {"mm", 5, w40, h60, w60, h40, 1}, {"mr", 6, w60, h60, w80, h40, 0},
        {"bl", 7, w20, h80, w40, h60, 0}, {"bm", 8, w40, h80, w60, h60, 2}, {"br", 9, w60, h80, w80, h60, 0}
    }

    assert_equal(hardLogic(board), 9)

end

function testSecondCondition()
    --Preventing creating two lines in row
    local board = {
        {"tl", 1, w20, h40, w40, h20, 1}, {"tm", 2, w40, h40, w60, h20, 0}, {"tr", 3, w60, h40, w80, h20, 0},
        {"ml", 4, w20, h60, w40, h40, 0}, {"mm", 5, w40, h60, w60, h40, 2}, {"mr", 6, w60, h60, w80, h40, 0},
        {"bl", 7, w20, h80, w40, h60, 0}, {"bm", 8, w40, h80, w60, h60, 0}, {"br", 9, w60, h80, w80, h60, 1}
    }

    assert_equal(hardLogic(board), 2)
end

function testThirdCondition()
    --If centre is free
    local board = {
        {"tl", 1, w20, h40, w40, h20, 0}, {"tm", 2, w40, h40, w60, h20, 0}, {"tr", 3, w60, h40, w80, h20, 0},
        {"ml", 4, w20, h60, w40, h40, 0}, {"mm", 5, w40, h60, w60, h40, 0}, {"mr", 6, w60, h60, w80, h40, 0},
        {"bl", 7, w20, h80, w40, h60, 0}, {"bm", 8, w40, h80, w60, h60, 0}, {"br", 9, w60, h80, w80, h60, 0}
    }

    assert_equal(hardLogic(board), 5)
end

function testFourthCondition()
    --Playing on any empty square
    local board = {
        {"tl", 1, w20, h40, w40, h20, 1}, {"tm", 2, w40, h40, w60, h20, 2}, {"tr", 3, w60, h40, w80, h20, 1},
        {"ml", 4, w20, h60, w40, h40, 2}, {"mm", 5, w40, h60, w60, h40, 1}, {"mr", 6, w60, h60, w80, h40, 2},
        {"bl", 7, w20, h80, w40, h60, 2}, {"bm", 8, w40, h80, w60, h60, 1}, {"br", 9, w60, h80, w80, h60, 0}
    }

    assert_equal(hardLogic(board), 9)
end

function testFifthCondition()
    --Play the opposite corner after opponent has played a corner
    local board = {
        {"tl", 1, w20, h40, w40, h20, 2}, {"tm", 2, w40, h40, w60, h20, 0}, {"tr", 3, w60, h40, w80, h20, 0},
        {"ml", 4, w20, h60, w40, h40, 0}, {"mm", 5, w40, h60, w60, h40, 1}, {"mr", 6, w60, h60, w80, h40, 0},
        {"bl", 7, w20, h80, w40, h60, 1}, {"bm", 8, w40, h80, w60, h60, 0}, {"br", 9, w60, h80, w80, h60, 0}
    }

    assert_equal(hardLogic(board), 3)
end

function testUndoMove()
    assert_function(undoMove, "UndoMove is a function")
end

function testReplayGame()
    assert_function(previousGame, "PreviousGame is a function")
end

function testClearScore()
    assert_function(clearScore, "ClearScore is a function")
end

function testEasyMode()
    assert_function(computerMoveEasy, "computerMoveEasy is a function")
end

function testHardMode()
    assert_function(computerMoveHard, "computerMoveHard is a function")
end