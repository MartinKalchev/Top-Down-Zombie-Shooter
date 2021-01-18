zombies = {}
maxSpawnTime = 2
timer = maxSpawnTime

function spawnZombie()
    zombie = {}
    zombie.x = 0
    zombie.y = 0
    zombie.speed = 100
    zombie.dead = false

    local spawnSide = math.random(1, 4)

    if spawnSide == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif spawnSide == 2 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif spawnSide == 3 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    else
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end

    table.insert(zombies, zombie)
end

function zombiesUpdate(dt)
    for i,z in ipairs(zombies) do
        z.x = z.x + math.cos(zombieFacePlayer(z)) * z.speed * dt
        z.y = z.y + math.sin(zombieFacePlayer(z)) * z.speed * dt

        if checkCollision(z.x, z.y, player.x, player.y) < 30 then
            for i,z in ipairs(zombies) do
                zombies[i] = nil
                gameState = 1
                player.x = love.graphics.getWidth()/2
                player.y = love.graphics.getHeight()/2
            end
        end
    end

    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do
            if checkCollision(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
                score = score + 1
                blip_sound:play()
            end
        end
    end

    for i=#zombies,1,-1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
        end
    end

    for i=#bullets,1,-1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end

    if gameState == 2 then
        timer = timer - dt
        if timer <= 0 then
            spawnZombie()
            maxSpawnTime = maxSpawnTime * 0.97
            timer = maxSpawnTime
        end
    end
end


function zombieFacePlayer(enemy)
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function checkCollision(x1,y1,x2,y2)
    return math.sqrt((y2-y1)^2 + (x2 - x1)^2)
end