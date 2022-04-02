import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local cursorIndex = 1
local attempt = ""
local keyboardArray = { 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '\n', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '\n', 'Z', 'X', 'C', 'V', 'B', 'N', 'M' }

local kFirstOfFirstLine <const> = 1
local kFirstOfSecondLine <const> = 12
local kFirstOfThirdLine <const> = 22
local kLastOfFirstLine <const> = 10
local kLastOfSecondLine <const> = 20
local kLastOfThirdLine <const> = 28

function updateText()

    local keyboardRendered = ""
    for i = 1, 28 do
        local keyToAdd = keyboardArray[i]
        if cursorIndex == i then
            keyToAdd = "*" .. keyToAdd .. "*"
        end
        keyboardRendered = keyboardRendered .. keyToAdd
    end
    keyboardRendered = keyboardRendered
    gfx.clear()
    gfx.drawTextAligned(attempt, 200, 60, kTextAlignment.center)
    gfx.drawTextAligned(keyboardRendered, 200, 120, kTextAlignment.center)

end

function moveForward()
    if cursorIndex >= kLastOfThirdLine then
        return
    end

    local moveBy = 1
    if cursorIndex == kLastOfFirstLine or cursorIndex == kLastOfSecondLine then
        moveBy = 2
    end
    cursorIndex = cursorIndex + moveBy
end

function moveBack()
    if cursorIndex <= kFirstOfFirstLine then
        return
    end

    local moveBy = 1
    if cursorIndex == kFirstOfSecondLine or cursorIndex == kFirstOfThirdLine then
        moveBy = 2
    end
    cursorIndex = cursorIndex - moveBy
end

function playdate.update()

    local crankStatus = playdate.getCrankChange()
    if playdate.buttonJustPressed(playdate.kButtonRight) or crankStatus > 0 then
        moveForward()
    end

    if playdate.buttonJustPressed(playdate.kButtonLeft) or crankStatus < 0 then
        moveBack()
    end

    if playdate.buttonJustPressed(playdate.kButtonA) then
        attempt = attempt .. keyboardArray[cursorIndex]
    end

    if playdate.buttonJustPressed(playdate.kButtonB) then
        local stop = string.len(attempt) - 1
        attempt = string.sub(attempt, 1, stop)
    end
    updateText()

    playdate.timer.updateTimers()

end