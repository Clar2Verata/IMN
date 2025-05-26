FonTable = Object:extend()

function FonTable:new(CurX, CurY)
	self.font = "fonts/HurmitNerdFontMonoReg.otf"
	self.fontSize = 16
	self.hurmitF = love.graphics.setNewFont(self.font, self.fontSize)
	self.wraplength = 710
	self.lheight = 0
	self.kerning = 0

	self.startColor = { (158 / 255), (211 / 255), (165 / 255), 1 }

	self.lHeight = self.hurmitF:getHeight()
	self.kerning = self.hurmitF:getWidth(" ")
	self.CurstartX = CurX + self.kerning
	self.CurstartY = CurY + (self.lHeight * 2)
end

function FonTable:update(dt)
	require("tick")
end

function FonTable:draw(curText, textColor)
	love.graphics.setColor(textColor)
	love.graphics.printf(curText, self.CurstartX, self.CurstartY, self.wraplength)
end
