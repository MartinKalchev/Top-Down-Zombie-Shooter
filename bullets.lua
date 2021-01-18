bullets = {}

function updateBullet(dt)
    for i,b in ipairs(bullets) do
        b.x = b.x + math.cos(b.direction) * b.speed * dt
        b.y = b.y + math.sin(b.direction) * b.speed * dt
    end

    for i = #bullets,1,-1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end
end

function spawnBullet()
    bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 450
    bullet.direction = playerFaceMouse()
    bullet.dead = false

    table.insert(bullets, bullet)
end


function love.mousepressed(x, y, b, istouch)
    if b == 1 and gameState == 2 then
        spawnBullet()
    end

    if gameState == 1 then
        gameState = 2
        maxSpawnTime = 2
        timer = maxSpawnTime
        score = 0
    end
end