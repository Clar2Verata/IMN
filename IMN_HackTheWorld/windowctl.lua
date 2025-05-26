Windowctl = Object:extend()

function Windowctl:new()
	self.x = 900
	self.y = 900

	self.xpad = 40
	self.ypad = 30

	self.ulength = 80
	self.vlength = 33

	self.boxPadx = 25
	self.boxPady = 25

	self.cornerArt1 = "┏┐"
	self.cornerArt2 = "└┛"

	self.horizLine1 = "_"
	self.horizLine2 = "-"
	self.vertLineL = "┋|"
	self.vertLineR = "|┋"

	love.window.setMode(self.x, self.y)
end

function Windowctl:update(dt)
	require("tick")
end

function Windowctl:draw()
	self:BuildHorizontalBars(self.ulength)
end

function Windowctl:BuildHorizontalBars(ulength)
	local linebar = self.cornerArt1
	linebar = linebar .. self:BuildHorizline(ulength, self.horizLine1) .. self.cornerArt1 .. "\n"
	linebar = linebar .. self.cornerArt2 .. self:BuildHorizline(ulength, self.horizLine2) .. self.cornerArt2
	linebar = linebar .. self:BuildVertline(self.vlength, self.vertLineL)
	linebar = linebar
		.. "\n"
		.. self.cornerArt1
		.. self:BuildHorizline(ulength, self.horizLine1)
		.. self.cornerArt1
		.. "\n"
	linebar = linebar .. self.cornerArt2 .. self:BuildHorizline(ulength, self.horizLine2) .. self.cornerArt2

	love.graphics.print(linebar, self.boxPadx, self.boxPady)
end

function Windowctl:BuildHorizline(ulength, lineSection)
	local linebar = ""
	for i = 1, ulength do
		linebar = linebar .. lineSection
	end
	return linebar
end

function Windowctl:BuildVertline(vlength, linesection)
	local linebar = ""
	for i = 1, vlength do
		linebar = linebar .. "\n" .. linesection .. self:Addspace(self.ulength) .. self.vertLineR
	end
	return linebar
end

function Windowctl:Addspace(ulength)
	local safeSpace = ""
	for i = 1, ulength do
		safeSpace = safeSpace .. " "
	end
	return safeSpace
end
