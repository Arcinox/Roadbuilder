--------------------------------------------------------------------------------------------------------------------------------------------
-- Author: Jennifer Gold												      		  --
-- Project Title: Roadbuilder												       		  --
-- Version: 1.0.0.0													       		  --
-- Purpose: To explore and demonstrate one possible road management system, as if it were part of a larger city-building simulation game. --
-- Additional Credits: Bart van Strien for the pseudo-class implementation (all contents of "class.lua")
--------------------------------------------------------------------------------------------------------------------------------------------


require("tool")

tools = {}

function love.load()
	bg_img = love.graphics.newImage('img/grass.png')
	bg_img:setWrap("repeat", "repeat")
	bg_quad = love.graphics.newQuad(0,0,1024,1024,bg_img:getWidth(), bg_img:getHeight())
	love.keyboard.setKeyRepeat(true)
	icon_img = love.image.newImageData('img/rbicon.png')
	love.window.setIcon(icon_img)
end

function love.draw(dt)
	love.graphics.draw(bg_img, bg_quad, 0, 0)
	love.graphics.print("Build a road system using different road pieces!\n\nPress A for a Straight.\nPress S for a Bend.\nPress D for a Crossroad.\nPress F for a T-Junction.\nPress X for a random piece.\n\nUse Q and E to rotate pieces.\nPress Esc to remove a grabbed piece!")
	local count = 0
	for i,v in ipairs(tools) do
		if v ~= nil then
			count = count + 1
			if (v.isFollowing and v.icon:typeOf("Drawable")) then
				love.graphics.draw(v.shadow, v.trueX, v.trueY, v.rotation, 1, 1, v:GetMiddleX(), v:GetMiddleY())
			end
			love.graphics.draw(v.icon, v.visualX, v.visualY, v.rotation, 1, 1, v:GetMiddleX(), v:GetMiddleY())
		end
	end
end

function love.focus(f) isPaused = not f end

function love.update()
	if isPaused then return end
	local mx, my = love.mouse.getPosition()

	function love.mousereleased(x, y, button)
		if button == 'l' then
			for i,v in ipairs(tools) do
				if (v:HasIntersected(x, y)) then
					if v.isFollowing then
						v:StopFollowing()
					else
						v:StartFollowing(x, y)
					end
				end
			end
		end
	end

	function love.keypressed(key)
		if key == 'x' then
			tool:new(love.math.random(4), mx, my)
		elseif key == 'a' then
			tool:new(1, mx, my)
		elseif key == 's' then
			tool:new(2, mx, my)
		elseif key == 'd' then
			tool:new(3, mx, my)
		elseif key == 'f' then
			tool:new(4, mx, my)			
		elseif key == 'q' or key == 'e' then
			for i,v in ipairs(tools) do
				if v.isFollowing then
					if key == 'q' then
						v:RotateAntiClockwise()
				elseif key == 'e' then
					v:RotateClockwise()
				end
			end
		end
		elseif key == 'escape' then
			local count = 0
			for i,v in ipairs(tools) do
				count = count + 1
			end
			while count > 0 do
				if tools[count].isFollowing == true then
					table.remove(tools, count)
				end
			count = count - 1
			end
		end
	end

	for i,v in ipairs(tools) do
		if v.isFollowing then
			v:Follow()
		end
	end
end

function love.unload()
	for i,v in ipairs(tools) do
		v:dispose()
	end
	tools = nil
end