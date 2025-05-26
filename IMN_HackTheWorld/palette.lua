Palette = Object:extend()

function Palette:new()
	self.p1 = { 218, 247, 166 } --#DAF7A6
	self.p2 = { 255, 195, 0 } ----#FFC300
	self.p3 = { 255, 87, 51 } ----#FF5733
	self.p4 = { 199, 0, 57 } -----#C70039
	self.p5 = { 144, 12, 63 } ----#900C3F
	self.p6 = { 88, 24, 69 } -----#581845

	self:ConstructTruePalette()
end

function Palette:ConstructTruePalette()
	local colorSalon = { self.p1, self.p2, self.p3, self.p4, self.p5, self.p6 }

	for i = 1, #colorSalon do
		for g = 1, #colorSalon[i] do
			(colorSalon[i])[g] = (colorSalon[i])[g] / 255
		end
		table.insert(colorSalon[i], 4, 1)
	end
end
