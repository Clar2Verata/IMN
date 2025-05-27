FonTable = Object:extend()

function FonTable:new(CurX, CurY)
	self.font = "fonts/HurmitNerdFontMonoReg.otf"
	self.fontSize = 16
	self.hurmitF = love.graphics.setNewFont(self.font, self.fontSize)
	self.wraplength = 780

	self.startX = CurX
	self.startY = CurY
	self.startColor = { (158 / 255), (211 / 255), (165 / 255), 1 }

	self.lHeight = self.hurmitF:getHeight()
	self.kerning = self.hurmitF:getWidth(" ")
end

function FonTable:draw(curText)
	love.graphics.printf(curText, self.startX, self.startY, self.wraplength)
end
