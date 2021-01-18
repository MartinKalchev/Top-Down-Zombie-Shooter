function love.load()
    love.window.setMode(896, 800)

    sprites = {}
    sprites.player = love.graphics.newImage('Assets/player.png')
    sprites.bullet = love.graphics.newImage('Assets/bullet.png')
    sprites.zombie = love.graphics.newImage('Assets/zombie.png')
    sprites.background = love.graphics.newImage('Assets/background.png')
    blip_sound = love.audio.newSource("Assets/blip.wav", "static")
    
    require('player')
    require('zombies')
    require('bullets')
    require('show')

    gameState = 1

    myFont = love.graphics.newFont(40)

    gameTimer = 0

    savedData = {}
    savedData.bestScore = 0

    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end
end


function love.update(dt)
    playerUdpate(dt)
    zombiesUpdate(dt)
    updateBullet(dt)

    if gameState == 2 then
        gameTimer = gameTimer + dt
    end

    if gameState == 1 then
        gameTimer = 0
    end

    if score > savedData.bestScore then
        savedData.bestScore = score
        love.filesystem.write("data.lua", table.show(savedData, "savedData"))
    end
end



function love.draw()
    love.graphics.draw(sprites.background, 0, 0)

    if gameState == 1 then
        love.graphics.setFont(myFont)
        love.graphics.printf("Click to begin!", 0, 50, love.graphics.getWidth(), "center")
        love.graphics.printf("Highscore: " .. savedData.bestScore, 0, 100, love.graphics.getWidth(), "center")
    end

    if gameState == 2 then
        love.graphics.printf("Score:" .. score, 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")
        love.graphics.printf("Time survived:" .. math.floor(gameTimer), 3, love.graphics.getHeight() - 100, love.graphics.getWidth())
    end
    

    love.graphics.draw(sprites.player, player.x, player.y, playerFaceMouse(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)

    for i,z in ipairs(zombies) do
        love.graphics.draw(sprites.zombie, z.x, z.y, zombieFacePlayer(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end

    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, 0.5, 0.5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end


