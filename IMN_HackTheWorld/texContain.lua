TexContain = Object:extend()

require("shape")

function TexContain:new(WindowcX, WindowcY)
	self.boxPadx = 25
	self.boxPady = 25

	self.windowcX = WindowcX
	self.windowcY = WindowcY
	self.cornerArt1 = "┏┐" .. "\n" .. "└┛"

	self.horizLine = "\n˭" .. "\n▁"

	self.vertLine = "┋‖"
end

function TexContain:update(dt)
	require("tick")
end

function TexContain:draw()
	self:BuildCorners()
end

function TexContain:BuildCorners()
	local x = 0
	local y = 0
	love.graphics.print(self.cornerArt1, self.boxPadx, self.boxPady)
	x = self.windowcX - self.boxPadx * 2
	love.graphics.print(self.cornerArt1, x, self.boxPady)
	y = self.windowcY - self.boxPady * 3
	love.graphics.print(self.cornerArt1, self.boxPadx, y)
	love.graphics.print(self.cornerArt1, x, y)
end
