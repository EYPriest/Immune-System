Bacteria = Class{ __includes = Cell }

function Bacteria:init( pos )

  self.sprite = love.graphics.newImage("res/Bacteria1.png")
  
  Cell.init(self,pos)
  
  self.direction_range_low = -90
  self.direction_range_high = 90
  
  self.speed = 1.2
  self.friction = 0.01
  
  self.move_rate = 2
  
end

function Bacteria:update(dt)
  
    -- Get ready to move
  self.move_acc = self.move_acc + dt
  if ( self.move_acc >= self.move_rate ) then
    self.move_acc = self.move_acc - self.move_rate
    local theta = math.rad(love.math.random(0,180) - 90)
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

function Bacteria:draw()
  
  love.graphics.setColor(1,1,1,0.8)
  love.graphics.draw(self.sprite,self.pos.x,self.pos.y,0,SCALE,SCALE)
  love.graphics.setColor(1,1,1,1)
    
end
