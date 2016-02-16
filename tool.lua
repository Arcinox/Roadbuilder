require("class")

tool = {}

tool = class:new()
tool.type = 0
tool.name = ''
tool.icon = ''
tool.shadow = ''
tool.trueX = 0
tool.trueY = 0
tool.visualX = 0
tool.visualY = 0
tool.isFollowing = false
tool.rotation = 0
tool.originX = 0
tool.originY = 0

local typetable = {
	{id = 1, name = 'Straight', iconString = 'img/roadstraighttp.png', shadowString = 'img/roadstraightshdw.png'},
	{id = 2, name = 'Bend', iconString = 'img/roadcurvetp.png', shadowString = 'img/roadcurveshdw.png'},
	{id = 3, name = 'Crossroads', iconString = 'img/roadcrosstp.png', shadowString = 'img/roadcrossshdw.png'},
	{id = 4, name = 'T-Junction', iconString = 'img/roadteetp.png', shadowString = 'img/roadteeshdw.png'}
	}

function tool:init(id, mx, my)
	self.type = id
	self.name = typetable[self.type].name
	self.icon = love.graphics.newImage(typetable[self.type].iconString)
	self.shadow = love.graphics.newImage(typetable[self.type].shadowString)
	self.trueX = mx
	self.trueY = my
	self.visualX = mx
	self.visualY = my
	self.isFollowing = true
	self.originX = 0
	self.originY = 0
	table.insert(tools, self)
end

function tool:Follow()
	local mx, my = love.mouse.getPosition()
	self.trueX, self.trueY = mx - self.originX, my - self.originY
	self.visualX, self.visualY = self.trueX + 10, self.trueY - 10
end

function tool:StartFollowing(mx, my)
	self.isFollowing = true
	self.originX, self.originY = mx - self.trueX, my - self.trueY
end

function tool:StopFollowing()
	self.isFollowing = false
	self.visualX, self.visualY = self.trueX, self.trueY
	self.originX, self.originY = 0, 0
end

function tool:RotateClockwise()
	if (self.rotation >= math.rad(270)) then
		self.rotation = 0
	else self.rotation = self.rotation + math.rad(90) end
end

function tool:RotateAntiClockwise()
	if (self.rotation <= 0) then
		self.rotation = math.rad(270)
	else self.rotation = self.rotation - math.rad(90) end
end

function tool:GetMiddleX()
	return self.icon:getWidth() / 2
end

function tool:GetMiddleY()
	return self.icon:getHeight() / 2
end

function tool:HasIntersected(lx, ly)
	if (lx >= (self.trueX - self:GetMiddleX()) and lx <= (self.trueX + self:GetMiddleX()))
		and (ly >= (self.trueY - self:GetMiddleY()) and ly <= (self.trueY + self:GetMiddleY())) then
		return true
	else
		return false
	end
end


function tool:dispose()
	self.type = nil
	self.name = nil
	self.icon = nil
	self.trueX = nil
	self.trueY = nil
	self.isFollowing = nil
	self.shadow = nil
	self.visualX = nil
	self.visualY = nil
	self.active = nil
	self.originX = nil
	self.originY = nil
	self = nil
end