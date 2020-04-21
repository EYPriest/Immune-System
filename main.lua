Class = require "hump.class"
Vector = require 'hump.vector'

local lg = love.graphics

--Set scale algorithm before importing sprites
love.graphics.setDefaultFilter("nearest","nearest")

--SCALE = love.graphics.getWidth() / 240
SCALE = love.graphics.getWidth() / 320
--SCALE = 2

print(SCALE)

--Files
require "cell"
require "bacteria"
require "macrophage"
require "neutrophil"

bacterias = {}
bacteria_spawn_time = 1.4
bacteria_spawn_acc = 0

phagocites = {}

bg_foreground = nil
bg_background = nil

--buttons
pressing_button_one = false
pressing_button_two = false

--Inputs
function love.keypressed(key)
  
  if key == 'escape' then
    love.event.quit( 0 )
  else
    --Player:keypressed(key)
  end

end

function love.keyreleased(key)
  --Player:keyreleased(key)
end

function love.mousepressed(x,y,button,istouch)
    --Player:mousepressed(x,y,button,istouch)
    --ButtonSwitchRes:mousepressed(x,y,button,istouch)
    --ButtonDebug:mousepressed(x,y,button,istouch)
    
    if ( x>=247*SCALE and x<(247+20)*SCALE and y>=4*SCALE and y<(4+20)*SCALE ) then
      pressing_button_one = true
    elseif ( x>=271*SCALE and x<(271+25)*SCALE and y>=4*SCALE and y<(4+25)*SCALE ) then
      pressing_button_two = true
    end
    
end

function love.mousereleased(x,y,button,istouch)
    --Player:mousereleased(x,y,button,istouch)
    --ButtonSwitchRes:mousereleased(x,y,button,istouch)
    --ButtonDebug:mousereleased(x,y,button,istouch)
    
    if ( x>=247*SCALE and x<(247+20)*SCALE and y>=4*SCALE and y<(4+20)*SCALE and pressing_button_one) then
      local pos = Vector(love.math.random(240*SCALE),love.math.random(240*SCALE))
      table.insert(phagocites,Neutrophil(pos))
    elseif ( x>=271*SCALE and x<(271+25)*SCALE and y>=4*SCALE and y<(4+25)*SCALE and pressing_button_two) then
      local pos = Vector(love.math.random(240*SCALE),love.math.random(240*SCALE))
      table.insert(phagocites,Macrophage(pos))
    end
    
    pressing_button_one = false
    pressing_button_two = false
    
end

function love.load()
  
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  --love.graphics.setDefaultFilter( min, mag, anisotropy )
  --love.graphics.setDefaultFilter( "nearest" )
  --love.graphics.setDefaultFilter("nearest","nearest")
  
  
  --Player.load()
  --Asteroid:load()
  
  --bg = love.graphics.newImage("res/Level1.png")
  bg_foreground = love.graphics.newImage("res/Level1-foreground.png")
  bg_background = love.graphics.newImage("res/Level1-background.png")
  
  
end

--Update
function love.update(dt)
  
  bacteria_spawn_acc = bacteria_spawn_acc + dt
  --print (" spawn_acc :" .. spawn_acc )
  if ( bacteria_spawn_acc >= bacteria_spawn_time ) then
    bacteria_spawn_acc = bacteria_spawn_acc - bacteria_spawn_time
    
    local bx = love.math.random(240*SCALE)
    local by = love.math.random(240*SCALE)
    local b = Bacteria(Vector(bx,by))
    table.insert(bacterias,b)
    --print( " new bac " )
  end
  
  for i,bac in ipairs( bacterias ) do
    --love.graphics.draw(bac,bac.pos.x,pac.pos.y,0,SCALE,SCALE)
    bac:update(dt)
  end
  
  for i,phago in ipairs( phagocites ) do
    --love.graphics.draw(bac,bac.pos.x,pac.pos.y,0,SCALE,SCALE)
    phago:update(dt)
  end
  
end

--Draw
function love.draw()
  
  --love.graphics.draw(bg,0,0,0,SCALE,SCALE
  love.graphics.draw(bg_background,0,0,0,SCALE,SCALE)
  
  for i,bac in ipairs( bacterias ) do
    --love.graphics.draw(bac,bac.pos.x,pac.pos.y,0,SCALE,SCALE)
    bac:draw()
  end
  
  for i,phago in ipairs( phagocites ) do
    --love.graphics.draw(bac,bac.pos.x,pac.pos.y,0,SCALE,SCALE)
    phago:draw()
  end
  
  love.graphics.setColor(1,1,1,0.8)
  love.graphics.draw(bg_foreground,0,0,0,SCALE,SCALE)
  love.graphics.setColor(1,1,1,1)
  
end

--AABB to AABB
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  -- Collision detection function;
  -- Returns true if two boxes overlap, false if they don't;
  -- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
  -- x2,y2,w2 & h2 are the same, but for the second box.
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
