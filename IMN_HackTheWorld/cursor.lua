Cursor = Object:extend()
require("tick")
function Cursor:new(xPad, yPad, kerning, lheight, wrap)
	------#Cursor-Forms#------|
	self.cursorent = "█" -----|  --this is the current cursor glyph on display
	--------------------------|
	self.curOn = "█" ---------|
	self.curOff = "░" --------|
	--------------------------|
	self.blOn = "█" ----------|
	self.blOff = "░" ---------|
	--------------------------|
	self.inOn = "/" ----------|
	self.inOff = "|" ---------|
	--------------------------|
	self.repOn = "_" ---------|
	self.repOff = "-" --------|
	------#Cursor-Forms#------|

	self.x = xPad
	self.y = yPad

	self.xPad = xPad
	self.yPad = yPad
	self.textPosX = 1
	self.textPosY = 1
	self.textLenPos = 1

	self.trueStringLen = 0
	self.wrap = wrap / kerning
	self.lheight = lheight --the space between lines
	self.kerning = kerning
	self.textOffSet = -(kerning / 2)
	self.blink = 1
	self.bCooldown = self.blink
	self.typeDrag = true
	self.spaceSpeed = 5
	self.showPos = true
	self.status = "normal"
end

function Cursor:update(dt)
	Cursor:Blink(dt)
end

function Cursor:draw()
	love.graphics.print(self.cursorent, self.x, self.y)
	if self.showPos then
		love.graphics.print(
			"x: "
				.. self.textPosX
				.. " y: "
				.. self.textPosY
				.. " Len: "
				.. self.textLenPos
				.. " trueCount: "
				.. self.trueStringLen,
			5,
			5
		)
	end
end

-----------==Function City 13==----------------------------

---//--//-=Blink-Cursor functions=-\\--\\---
---______________________________________---
function Cursor:Swapblink(cursor)
	local blinker
	if cursor == self.curOn then
		blinker = self.curOff
	elseif cursor == self.curOff then
		blinker = self.curOn
	end
	return blinker
end

function Cursor:Blink(dt)
	if self.bCooldown <= 0 then
		self.cursorent = Cursor:Swapblink(self.cursorent)
		self.bCooldown = self.blink
	else
		self.bCooldown = self.bCooldown - dt
	end
end
---//--//-=Blink-Cursor functions=-\\--\\---
---______________________________________---

function Cursor:Move(xDir, yDir, kerning, lheight)
	if self.textPosX + xDir < 1 or self.textPosX + xDir > self.wrap then
	elseif self.textPosY + yDir < 1 or self.textPosY + yDir > 900 then
	else
		self.x = self.x + (xDir * kerning)
		self.y = self.y + (yDir * lheight)
		self.textPosX = self.textPosX + xDir
		self.textPosY = self.textPosY + yDir
	end
	self:FindTruetextPos()
end

function Cursor:ApplyOffset(bool)
	if bool then
		self.x = self.x + self.textOffSet
	else
		self.x = self.x - self.textOffSet
	end
end

function Cursor:NewLinecheck(wordwrap, kerning, lheight)
	if self.textPosX > (wordwrap / kerning) - 1 then
		self.x = self.xPad

		self.textPosX = 1
		self:Move(0, 1, kerning, lheight)
	elseif self.textPosX <= 0 then
		self:Move(0, 1, kerning, lheight)
		self.x = wordwrap - 1
		self.textPosX = (wordwrap / kerning) - 1
	else
		self:Move(1, 0, kerning, lheight)
	end
	self:FindTruetextPos()
end

function Cursor:FindTruetextPos()
	local yfixed = ((self.textPosY - 1) * self.wrap)
	if self.textPosY > 1 then
		yfixed = yfixed - 10
	end
	self.textLenPos = self.textPosX + yfixed
end

---/\Cursor-Modes-------\--
---
function Cursor:NormMode(dt)
	require("tick")
	if self.textOffSet ~= 0 then
		self.textOffSet = -self.textOffSet
		self:ApplyOffset()
		self.textOffSet = 0
	end

	self.curOff = self.blOff
	self.curOn = self.blOn
	self.bCooldown = 0
	self:Blink(dt)
	self.cursorent = self.curOn
	self.status = "normal"
	self:ApplyOffset()
	self.textOffSet = 0
end
function Cursor:InsMode(dt)
	require("tick")
	self.curOff = self.inOff
	self.curOn = self.inOn
	self.bCooldown = 0
	self:Blink(dt)
	self.cursorent = self.curOn
	self.status = "insert"
	self.textOffSet = (self.kerning / 2)
	self:ApplyOffset()
end
function Cursor:AppMode(dt)
	require("tick")
	self.curOff = self.inOff
	self.curOn = self.inOn
	self.bCooldown = 0
	self:Blink(dt)
	self.cursorent = self.curOn
	self.status = "append"
	self.textOffSet = -(self.kerning / 2)
	self:ApplyOffset()
end
--/-------------------------------\
--|-------------------------------|

function Cursor:NormalInput(key, kerning, lheight)
	local xMov = 0
	local yMov = 0
	if string.len(key) < 2 then
		if key == "h" then
			xMov = -1
		elseif key == "l" then
			xMov = 1
		elseif key == "j" then
			yMov = 1
		elseif key == "k" then
			yMov = -1
		elseif key == "i" then
			self:InsMode()
		elseif key == "a" then
			self:AppMode()
		end
	end
	if xMov ~= 0 or yMov ~= 0 then
		Cursor:Move(xMov, yMov, kerning, lheight)
	end
end

function Cursor:Insput(letter, kerning, curText, wordwrap, lheight)
	local comboText = curText
	if self.textLenPos > self.trueStringLen + 1 then
		comboText = self:CheckAndAppendSpace(comboText)
	end
	if letter == "escape" then
		self:NormMode()
	elseif letter == "backspace" or letter == "delete" then
		local pushback = true
		comboText = self:DeleteSpace(pushback, comboText)
	elseif self.textLenPos < self.trueStringLen then
		comboText = self:GlyphInsertion(comboText, letter)
	elseif string.len(letter) < 2 then
		self:NewLinecheck(wordwrap, kerning, lheight)
		comboText = comboText .. letter
		self.trueStringLen = self.trueStringLen + 1
	elseif letter == "space" then
		comboText = comboText .. " "
		self:NewLinecheck(wordwrap, kerning, lheight)
		self.trueStringLen = self.trueStringLen + 1
	end

	return comboText
end

function Cursor:AppPut(letter, kerning, curText, wordwrap, lheight)
	local comboText = self:Insput(letter, kerning, curText, wordwrap, lheight)
	return comboText
end

function Cursor:CheckAndAppendSpace(curText)
	local addedSpace = self.textLenPos - self.trueStringLen - 2

	for i = 0, addedSpace do
		curText = curText .. " "
		self.textLenPos = self.textLenPos + 1
		self.trueStringLen = self.trueStringLen + 1
	end

	return curText
end

function Cursor:DeleteSpace(isPushback, curText)
	local textLength = string.len(curText)
	local sentenceHotel = {}
	local patron
	local checkoutText = ""
	for i = 1, textLength do
		patron = string.sub(curText, i, i)
		sentenceHotel[i] = patron
	end
	table.remove(sentenceHotel, self.textLenPos - 1)
	checkoutText = table.concat(sentenceHotel)

	if isPushback then
		self:Move(-1, 0, self.kerning, self.lheight)
	end
	return checkoutText
end

function Cursor:GlyphInsertion(curText, letter)
	local arsTech = {}
	local rune
	local checkoutText = ""

	if string.len(letter) < 2 then
		rune = letter
	elseif letter == "space" then
		rune = " "
	end

	for i = 1, #curText do
		arsTech[i] = curText:sub(i, i)
	end

	table.insert(arsTech, self.textLenPos, rune)

	checkoutText = table.concat(arsTech)

	self.trueStringLen = self.trueStringLen + 1

	self:Move(1, 0, self.kerning, self.lheight)
	return checkoutText
end
