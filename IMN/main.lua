Object = require("classic")
require("cursor")
require("windowctl")
require("fontable")

local curText = ""
function love.load()
	Windowctl = Windowctl()

	FonTable = FonTable(Windowctl.xpad, Windowctl.ypad)
	Cursor = Cursor(Windowctl.xpad, Windowctl.ypad, FonTable.kerning, FonTable.lHeight, Windowctl.ulength)
end

function love.update(dt)
	require("tick")
	Cursor:Blink(dt)
end

function love.draw()
	Cursor:draw()
	FonTable:draw(curText)
end
-------------Function-------------------
---
function love.keypressed(key)
	local letter = tostring(key)
	ResolveInput(letter)
end

function ResolveInput(letter)
	if Cursor.status == "normal" then
		Cursor:NormalInput(letter)
	elseif Cursor.status == "insert" then
		curText = Cursor:Insput(letter, curText)
	end
end
