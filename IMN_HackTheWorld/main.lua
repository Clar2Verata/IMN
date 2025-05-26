Object = require("classic")

require("cursor")
require("windowctl")
require("fontable")
require("palette")
require("texContain")

local curText = ""

function love.load()
	Windowctl = Windowctl()
	FonTable = FonTable(Windowctl.xpad, Windowctl.ypad)

	local x = Windowctl.boxPadx + (FonTable.kerning * 2)
	local y = Windowctl.boxPady + (FonTable.lHeight * 2)
	Cursor = Cursor(x, y, FonTable.kerning, FonTable.lHeight, 820)
	Palette = Palette()
	TexContain = TexContain(Windowctl.x, Windowctl.y)
end

function love.update(dt)
	require("tick")
	Cursor:Blink(dt)
end

function love.draw()
	Cursor:draw()
	FonTable:draw(curText, Palette.p2)
	Windowctl:draw()
end

-------FUNCTIONS--------
---
function love.keypressed(key)
	local letter = tostring(key)
	ResolveInput(letter, FonTable.kerning)
end

function ResolveInput(letter, kerning)
	if Cursor.status == "normal" then
		Cursor:NormalInput(letter, kerning, FonTable.lHeight)
	elseif Cursor.status == "insert" then
		curText = Cursor:Insput(letter, kerning, curText, FonTable.wraplength, FonTable.lHeight)
	elseif Cursor.status == "append" then
		curText = Cursor:AppPut(letter, kerning, curText, FonTable.wraplength, FonTable.lHeight)
	end
end
