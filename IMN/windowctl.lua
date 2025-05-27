Windowctl = Object:extend()

function Windowctl:new()
	self.dimX = 900
	self.dimY = 900

	self.xpad = 40
	self.ypad = 30

	self.ulength = 80
	self.vlength = 33

	self.cornerArt1 = "┏┐"
	self.cornerArt2 = "└┛"

	self.horizLine1 = "_"
	self.horizLine2 = "-"
	self.vertLineL = "┋|"
	self.vertLineR = "|┋"

	love.window.setMode(self.dimX, self.dimY)
end
