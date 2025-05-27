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
	self.xPad = xPad
	self.yPad = yPad
	self.x = xPad
	self.y = yPad
	self.textPoX = 1
	self.textPoY = 1

	self.lheight = lheight
	self.kerning = kerning
	self.wrap = wrap

	self.blink = 1
	self.bCooldown = self.blink

	self.status = "normal"

	self.scriptlength = 0
end

function Cursor:update(dt)
	Cursor:Blink(dt)
end

function Cursor:draw()
	love.graphics.print(self.cursorent, self.x, self.y)
	love.graphics.print(
		"x: " .. self.x .. " wrap: " .. self.wrap .. " textPoX: " .. self.textPoX .. " textPoY: " .. self.textPoY,
		5,
		5
	)
end
----------FUNCTION JUNCTION-------------
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

function Cursor:NormMode(dt)
	self.curOff = self.blOff
	self.curOn = self.blOn
	self.bCooldown = 0
	self:Blink(dt)
	self.cursorent = self.curOn
	self.status = "normal"
end
function Cursor:InsMode(dt)
	self.curOff = self.inOff
	self.curOn = self.inOn
	self.bCooldown = 0
	self:Blink(dt)
	self.cursorent = self.curOn
	self.status = "insert"
end
function Cursor:AppMode(dt)
	self.curOff = self.inOff
	self.curOn = self.inOn
	self.bCooldown = 0
	self:Blink(dt)
	self.cursorent = self.curOn
	self.status = "append"
end

function Cursor:Move(xDir, yDir)
	if self.textPoX + xDir < 1 or self.textPoX + xDir > self.wrap then
	elseif self.textPoY + yDir < 1 or self.textPoY + yDir > 900 then
	else
		self.x = self.x + (xDir * self.kerning)
		self.y = self.y + (yDir * self.lheight)
		self.textPoX = self.textPoX + xDir
		self.textPoY = self.textPoY + yDir
	end
end

function Cursor:NormalInput(key)
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
		Cursor:Move(xMov, yMov)
	end
end

function Cursor:Insput(letter, curText)
	local comboText = curText
	if letter == "escape" then
		self:NormMode()
	elseif string.len(letter) < 2 then
		comboText = comboText .. letter
		self.scriptlength = self.scriptlength + 1
		self:CheckForLinePush()
	elseif letter == "space" then
		comboText = comboText .. " "
		self.scriptlength = self.scriptlength + 1
		self:CheckForLinePush()
	end
	return comboText
end

function Cursor:CheckForLinePush()
	if self.textPoX >= self.wrap - 1 then
		self.x = self.xPad
		self:Move(0, 1)
		self:Move(1, 0)
		self.textPoX = 1
	else
		self:Move(1, 0)
	end
end
