-- Another Ether

-- Every file that needs access to the global variables file
--  simply needs to require 'globals'. the 'drawables' array
--  is included here.
require 'globals'

fRenderDelta = 0.0

-- Currently the skybox renders at the same color as ambience.
ambientLight = { 0.3, 0.3, 0.3, 1.0 }

-- My personal library:
m = lovr.filesystem.load('lib.lua'); m()

-- Abbreviations
fs = lovr.filesystem
gfx = lovr.graphics

-- Include the class files
require 'GameObject'
require 'Player'

function lovr.load(args)

    -- set up shader
    defaultVertex = fs.read('shaders/defaultVertex.vs')
    defaultFragment = fs.read('shaders/defaultFragment.fs')

    defaultShader = gfx.newShader(defaultVertex, defaultFragment, {})
    
    -- Set default shader values
    defaultShader:send('liteColor', {1.0, 1.0, 1.0, 1.0})
    defaultShader:send('ambience', ambientLight)
    defaultShader:send('specularStrength', 0.5)
    defaultShader:send('metallic', 32.0)

    --Try out our GameObject class!
    p = Player:new(0, 0, -3, 'models/female_warrior_1.obj')
    p:init() -- <- actually loads the model to drawables array
end

function lovr.update(dT)
    -- Light position updates
    defaultShader:send('lightPos', { 0.0, 2.0, -3.0 })

    -- Adjust head position (for specular)
    if lovr.headset then 
        hx, hy, hz = lovr.headset.getPosition()
        defaultShader:send('viewPos', { hx, hy, hz } )
    end

    fRenderDelta = math.floor(dT * 1000) -- in ms instead of us
end

function lovr.draw()
	-- skybox
	lovr.graphics.setColor(0.3, 0.3, 0.3, 1.0)
	lovr.graphics.box('fill', 0, 0, 0, 50, 50, 50, 0, 0, 1, 0)
	lovr.graphics.setColor(1.0, 1.0, 1.0, 1.0)
	
	-- model , normal shader
	lovr.graphics.setShader(defaultShader)
    local i 
    for i=1,#drawables do 
        drawables[i]:draw() -- global class constructor draw override test go!
    end

    -- ui, special shader
    lovr.graphics.setShader() -- Reset to default/unlit
    lovr.graphics.setColor(1, 1, 1, 1)
    lovr.graphics.print('hello world', 0, 2, -3, .5)
    lovr.graphics.print('Frame delta ' .. fRenderDelta .. 'ms', 0, 1, -3, 0.2)
    lovr.graphics.print("size of drawables: " .. #drawables, 0, 0, -3, 0.4)
end

function lovr.quit()
	-- QUITME
end
