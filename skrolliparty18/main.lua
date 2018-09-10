local moonshine = require 'moonshine'

local t = 0
 
function love.load()
    canvas = love.graphics.newCanvas(320, 240)

	effect = moonshine(moonshine.effects.crt)

	mainFont = love.graphics.newFont("main.ttf", 20)
	skrollilogo = love.graphics.newImage( "skrollilogo.png" )
end

function do_effect() 
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	love.graphics.push()
	    love.graphics.clear()
		love.graphics.setFont(mainFont)

	    love.graphics.setColor(0, 0.2, 0.2, 1.0)
	    love.graphics.rectangle('fill', 0, 00, 320, 240)

	    love.graphics.setColor(1, 1, 1, 1.0)
	    love.graphics.rectangle('fill', 50, 30, 200, 100)

	    love.graphics.setColor(1, 0, 0, 1.0)
		love.graphics.rectangle("fill", 150+math.sin(t*2.)*30,50, 100,100)

		love.graphics.push()
		    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
		    local x, y = 290-skrollilogo:getWidth()/2,150-skrollilogo:getHeight()/2
		    love.graphics.translate(x,y)

		    love.graphics.rotate(t)
		    love.graphics.translate(-x,-y)
		    love.graphics.draw(skrollilogo,x-128,y-32)
		love.graphics.pop()

	    love.graphics.setColor(1, 0, 1, 1.0)
	    love.graphics.print('Hello World!', 160+math.cos(t*3)*30, 150)
	love.graphics.pop()
end

function love.draw()
    love.graphics.setCanvas(canvas)
    	do_effect()
    love.graphics.setCanvas()

    love.graphics.clear()

    love.graphics.setColor(1, 1, 1, 1.0)

	effect.crt.time = t

	effect(function()
		love.graphics.push()
		love.graphics.scale(3.0, 3.0)
	    love.graphics.draw(canvas)
		love.graphics.pop()
	end)

end

function love.update(dt)
	t = t + dt
end