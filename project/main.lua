function love.load()
  bg = love.graphics.newImage("bg.png")
  
	hero = {}
	hero.x = 300
 	hero.y = 450
  hero.width = 30
  hero.height = 15
	hero.speed = 100
  hero.shots = {}
	
  enemies = {}
  for i=0,7 do
      enemy = {}
      enemy.width = 40
      enemy.height = 20
      enemy.x = i * (enemy.width + 60) + 100
      enemy.y = enemy.height + 100
      table.insert(enemies, enemy)
  end
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		hero.x = hero.x - hero.speed*dt
	elseif love.keyboard.isDown("right") then
		hero.x = hero.x + hero.speed*dt
	end
  
  local remEnemy = {}
  local remShot = {}
  
  -- update shots
  for i,v in ipairs(hero.shots) do
    v.y = v.y - dt * 100
    
    -- mark shots the fly off the top of the screen for removal
    if v.y < 0 then 
        table.insert(remShot, i)
    end
    
    -- check for collision between enemy and shot
    for ii,vv in ipairs(enemies) do
        if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then 
            -- mark enemy and shot for removal
            table.insert(remEnemy, ii)
            table.insert(remShot, i)
        end
    end
  end
  
  -- remove enemies
  for i,v in ipairs(remEnemy) do
    table.remove(enemies, v)
  end
  
  
  for i,v in ipairs(remShot) do
    table.remove(hero.shots, v)
  end
  
  -- update enemies
  for i,e in ipairs(enemies) do
    e.y = e.y + dt
    
    -- check for collision with ground
    if e.y > 465 then 
      -- you lose!!
    end
  end
end

function love.draw()
	-- draw background
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(bg)
  
  -- draw ground
  love.graphics.setColor(0,255,0,255)
	love.graphics.rectangle("fill", 0, 465, 800, 150)

  -- draw hero
	love.graphics.setColor(255,255,0,255)
	love.graphics.rectangle("fill", hero.x, hero.y, hero.width, hero.height)
  
  --draw enemies
  love.graphics.setColor(0,255,255,255)
  for i,v in ipairs(enemies) do
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end
  
  -- draw hero's shots
  love.graphics.setColor(0,0,255,255)
  for i,v in ipairs(hero.shots) do
    love.graphics.rectangle("fill", v.x, v.y, 2, 5)
  end
end

function love.keyreleased(key)
    if (key == " ") then 
      shoot()
    end
    
    if key == "escape" then 
      love.event.quit()
    end
end

function CheckCollision(x1,y1,w1,h1,x2,y2,w2,h2)
  return x1 < x2 + w2 and
    x2 < x1 + w1 and
    y1 < y2 + h2 and
    y2 < y1 + h1
end

function shoot()
  local shot = {}
  shot.x = hero.x + hero.width / 2
  shot.y = hero.y 
  table.insert(hero.shots, shot)
end