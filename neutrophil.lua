Neutrophil = Class{}

function Neutrophil:init( pos )

  self.sprite = love.graphics.newImage("res/Neutrophil1.png")
  self.pos = pos
  
  self.width = self.sprite:getWidth() * SCALE
  self.height = self.sprite:getHeight() * SCALE
  
  self.speed = 1.8
  self.current_speed = 0
  self.friction = 0.01
  self.direction = nil
  
  self.move_rate = 2
  self.move_acc = 0
  
  --[[
  self.speed = 2
  self.current_speed = 0
  self.friction = 0.04
  self.direction = nil
  
  self.move_rate = 0.8
  self.move_acc = 0
  --]]
  
end

function Neutrophil:update(dt)
  
  -- Get ready to move
  self.move_acc = self.move_acc + dt
  if ( self.move_acc >= self.move_rate ) then
    self.move_acc = self.move_acc - self.move_rate
    local theta = math.rad(love.math.random(0,360))
    local x_part = math.cos(theta)
    local y_part = math.sin(theta)
    self.direction = Vector(x_part,y_part)
    self.current_speed = self.speed
  end
  
  -- Movement
  if ( self.direction ~= nil ) then
    self.pos.x = self.pos.x + self.current_speed * self.direction.x
    self.pos.y = self.pos.y + self.current_speed * self.direction.y
    self.current_speed = self.current_speed - self.friction
    if ( self.current_speed <= 0 ) then self.current_speed = 0 end
    
    -- Wall Bounce
    if ( self.pos.x < 0 and self.direction.x < 0
      or self.pos.x + self.width > 240 * SCALE and self.direction.x > 0 ) then
      self.direction.x = self.direction.x * -1
    end
    if ( self.pos.y < 9  * SCALE and self.direction.y < 0
      or self.pos.y + self.height > 227  * SCALE and self.direction.y > 0 ) then
      self.direction.y = self.direction.y * -1
    end
  end
  
end

function Neutrophil:draw()
  
    love.graphics.setColor(1,1,1,0.8)
    love.graphics.draw(self.sprite,self.pos.x,self.pos.y,0,SCALE,SCALE)
    love.graphics.setColor(1,1,1,1)
    
end
