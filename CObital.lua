-- Cosmic Orbital Guardian - Плавное парение в небеса
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local activated = false
local orbs = {}
local connection = nil

-- Создаем GUI для активации
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CosmicOrbitalGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0.5, -160, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Переменные для перетаскивания
local dragging = false
local dragInput
local dragStart
local startPos

-- Функции для плавного перетаскивания
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

-- Обработчики перетаскивания для всего фрейма
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌌 Cosmic Orbital"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Индикатор перетаскивания
local dragHint = Instance.new("TextLabel")
dragHint.Size = UDim2.new(0, 20, 0, 20)
dragHint.Position = UDim2.new(1, -25, 0, 8)
dragHint.BackgroundTransparency = 1
dragHint.Text = "↖"
dragHint.TextColor3 = Color3.fromRGB(200, 200, 255)
dragHint.Font = Enum.Font.GothamBold
dragHint.TextSize = 14
dragHint.Parent = titleBar

-- Кнопка активации
local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.8, 0, 0, 50)
activateBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
activateBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 200)
activateBtn.Text = "✨ АКТИВИРОВАТЬ"
activateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
activateBtn.Font = Enum.Font.GothamBold
activateBtn.TextSize = 16
activateBtn.AutoButtonColor = true
activateBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = activateBtn

-- Информация
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 50)
infoLabel.Position = UDim2.new(0, 0, 0.65, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "4 радужных шара плавно парят\nНажми R для активации\nПеретаскивай меню за любую часть"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 11
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = mainFrame

-- Функция для создания радужного цвета
local function rainbowColor(timeOffset)
    local time = tick() * 0.5 + timeOffset
    local r = math.sin(time) * 0.5 + 0.5
    local g = math.sin(time + 2) * 0.5 + 0.5
    local b = math.sin(time + 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

-- Создание огненного шара
local function createOrb(orbIndex)
    local orb = Instance.new("Part")
    orb.Name = "CosmicOrb_" .. orbIndex
    orb.Size = Vector3.new(2, 2, 2)
    orb.Shape = Enum.PartType.Ball
    orb.Material = Enum.Material.Neon
    orb.CanCollide = false
    orb.Anchored = true
    orb.CastShadow = false
    orb.Transparency = 0
    
    -- Огненный эффект
    local fire = Instance.new("Fire")
    fire.Heat = 6
    fire.Size = 3
    fire.Color = Color3.new(1, 0.5, 0)
    fire.SecondaryColor = Color3.new(1, 1, 0)
    fire.Parent = orb
    
    -- Свечение
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 6
    pointLight.Range = 10
    pointLight.Shadows = true
    pointLight.Parent = orb
    
    -- Дым для дополнительного эффекта
    local smoke = Instance.new("Smoke")
    smoke.Opacity = 0.3
    smoke.Size = 2
    smoke.RiseVelocity = 2
    smoke.Color = Color3.new(1, 0.3, 0)
    smoke.Parent = orb
    
    orb.Parent = workspace
    return orb
end

-- Функция создания нежного взрыва
local function createGentleExplosion(position)
    -- Основной взрыв
    local mainExplosion = Instance.new("Part")
    mainExplosion.Name = "GentleRainbowExplosion"
    mainExplosion.Size = Vector3.new(1, 1, 1)
    mainExplosion.Shape = Enum.PartType.Ball
    mainExplosion.Material = Enum.Material.Neon
    mainExplosion.CanCollide = false
    mainExplosion.Anchored = true
    mainExplosion.CastShadow = false
    mainExplosion.Position = position
    
    local mainLight = Instance.new("PointLight")
    mainLight.Brightness = 15
    mainLight.Range = 20
    mainLight.Color = Color3.new(1, 1, 1)
    mainLight.Parent = mainExplosion
    
    mainExplosion.Parent = workspace
    
    -- Мелкие частицы вокруг
    for i = 1, 6 do
        spawn(function()
            wait(i * 0.15)
            local particle = Instance.new("Part")
            particle.Size = Vector3.new(0.3, 0.3, 0.3)
            particle.Shape = Enum.PartType.Ball
            particle.Material = Enum.Material.Neon
            particle.CanCollide = false
            particle.Anchored = true
            particle.CastShadow = false
            
            local angle = (i / 6) * math.pi * 2
            local distance = 3
            local x = math.cos(angle) * distance
            local z = math.sin(angle) * distance
            
            particle.Position = position + Vector3.new(x, 0, z)
            
            local particleLight = Instance.new("PointLight")
            particleLight.Brightness = 8
            particleLight.Range = 8
            particleLight.Color = rainbowColor(i * 0.8)
            particleLight.Parent = particle
            
            particle.Parent = workspace
            
            -- Плавная анимация частиц
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(particle, tweenInfo, {
                Size = Vector3.new(5, 5, 5),
                Transparency = 1
            })
            tween:Play()
            
            game:GetService("Debris"):AddItem(particle, 2)
        end)
    end
    
    -- Анимация основного взрыва
    local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(mainExplosion, tweenInfo, {
        Size = Vector3.new(12, 12, 12),
        Transparency = 1
    })
    tween:Play()
    
    -- Плавная смена цвета взрыва
    spawn(function()
        for i = 1, 12 do
            mainLight.Color = rainbowColor(i * 0.3)
            mainLight.Brightness = 15 + math.sin(i * 0.4) * 5
            wait(0.2)
        end
        game:GetService("Debris"):AddItem(mainExplosion, 3)
    end)
    
    return mainExplosion
end

-- Функция плавного парения вверх
local function gentleFloatToSky()
    if not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local startPositions = {}
    local floatTime = 4.0 -- Время парения
    local startTime = tick()
    local targetHeight = 50 -- Высота, на которую поднимутся шары
    
    -- Сохраняем стартовые позиции
    for i, orb in ipairs(orbs) do
        if orb then
            startPositions[i] = orb.Position
        end
    end
    
    -- Отключаем обычную анимацию
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    -- Создаем новое соединение для плавного парения
    connection = RunService.Heartbeat:Connect(function(delta)
        local currentTime = tick() - startTime
        local progress = currentTime / floatTime
        
        if progress >= 1 then
            connection:Disconnect()
            connection = nil
            -- Создаем взрыв на высоте
            local explosionPos = humanoidRootPart.Position + Vector3.new(0, targetHeight + 10, 0)
            createGentleExplosion(explosionPos)
            removeOrbsGracefully()
            return
        end
        
        -- Плавная кривая для мягкого движения
        local easeProgress = 1 - math.pow(1 - progress, 2) -- EaseOutQuad
        
        for i, orb in ipairs(orbs) do
            if orb and startPositions[i] then
                -- Медленное вращение во время подъема
                local rotationAngle = currentTime * 2 + (i * math.pi / 2)
                local rotationRadius = 2 + math.sin(currentTime * 3 + i) * 0.5
                
                -- Боковое движение (легкое колебание)
                local xOffset = math.cos(rotationAngle) * rotationRadius
                local zOffset = math.sin(rotationAngle) * rotationRadius
                
                -- Высота с плавным подъемом
                local currentHeight = startPositions[i].Y + (targetHeight * easeProgress)
                
                -- Новая позиция
                local newPosition = Vector3.new(
                    startPositions[i].X + xOffset,
                    currentHeight,
                    startPositions[i].Z + zOffset
                )
                
                orb.Position = newPosition
                
                -- Плавное изменение эффектов
                local orbColor = rainbowColor(i * 0.4 + currentTime * 0.8)
                orb.Color = orbColor
                
                -- Уменьшаем эффекты по мере подъема
                local fadeProgress = progress * 0.7
                
                local fire = orb:FindFirstChild("Fire")
                if fire then
                    fire.Color = orbColor
                    fire.SecondaryColor = Color3.new(
                        math.min(1, orbColor.R * 1.3),
                        math.min(1, orbColor.G * 1.3), 
                        math.min(1, orbColor.B * 1.3)
                    )
                    fire.Size = 3 * (1 - fadeProgress)
                    fire.Heat = 6 * (1 - fadeProgress)
                end
                
                local pointLight = orb:FindFirstChild("PointLight")
                if pointLight then
                    pointLight.Color = orbColor
                    pointLight.Brightness = 6 * (1 - fadeProgress * 0.5)
                    pointLight.Range = 10 * (1 - fadeProgress * 0.3)
                end
                
                local smoke = orb:FindFirstChild("Smoke")
                if smoke then
                    smoke.Size = 2 * (1 - fadeProgress)
                    smoke.RiseVelocity = 3 * (1 - fadeProgress * 0.5)
                    smoke.Opacity = 0.3 * (1 - fadeProgress)
                end
                
                -- Постепенное уменьшение размера
                local sizeScale = 1 - fadeProgress * 0.5
                orb.Size = Vector3.new(2, 2, 2) * sizeScale
                
                -- Постепенное исчезновение
                orb.Transparency = fadeProgress
            end
        end
    end)
end

-- Функция грациозного удаления шаров
local function removeOrbsGracefully()
    for i, orb in ipairs(orbs) do
        if orb then
            -- Отключаем эффекты
            local fire = orb:FindFirstChild("Fire")
            if fire then fire.Enabled = false end
            
            local pointLight = orb:FindFirstChild("PointLight")
            if pointLight then pointLight.Enabled = false end
            
            local smoke = orb:FindFirstChild("Smoke")
            if smoke then smoke.Enabled = false end
            
            game:GetService("Debris"):AddItem(orb, 1)
        end
    end
    orbs = {}
end

-- Основная функция анимации
local function startOrbitalAnimation()
    if not player.Character then return end
    
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Создаем 4 орба
    for i = 1, 4 do
        orbs[i] = createOrb(i)
    end
    
    local time = 0
    connection = RunService.Heartbeat:Connect(function(delta)
        if not player.Character or not humanoidRootPart then
            stopOrbitalAnimation()
            return
        end
        
        time = time + delta
        
        local characterPos = humanoidRootPart.Position
        local baseRadius = 6
        
        -- Обновляем каждый орб
        for i, orb in ipairs(orbs) do
            local orbOffset = i * math.pi/2
            local randomOffset = math.sin(time * 0.5 + i) * 0.8
            local heightVariation = math.cos(time * 1 + i) * 1.5
            
            local individualRadius = baseRadius + math.sin(time * 0.3 + i) * 1.5
            local angle = time * (1 + i * 0.15) + orbOffset + randomOffset
            
            local x = math.cos(angle) * individualRadius
            local z = math.sin(angle) * individualRadius
            local y = heightVariation + 1.5
            
            orb.CFrame = CFrame.new(characterPos + Vector3.new(x, y, z))
            
            local orbColor = rainbowColor(i * 0.5 + time * 0.6)
            orb.Color = orbColor
            
            local fire = orb:FindFirstChild("Fire")
            if fire then
                fire.Color = orbColor
                fire.SecondaryColor = Color3.new(
                    math.min(1, orbColor.R * 1.5),
                    math.min(1, orbColor.G * 1.5), 
                    math.min(1, orbColor.B * 1.5)
                )
                fire.Size = 3 + math.sin(time * 4 + i) * 1
            end
            
            local pointLight = orb:FindFirstChild("PointLight")
            if pointLight then
                pointLight.Color = orbColor
                pointLight.Brightness = 7 + math.sin(time * 3 + i) * 3
            end
            
            local pulse = 1 + math.sin(time * 4 + i) * 0.15
            orb.Size = Vector3.new(2, 2, 2) * pulse
        end
    end)
end

-- Функция остановки анимации
local function stopOrbitalAnimation()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    if #orbs > 0 then
        gentleFloatToSky()
    end
end

-- Обработчик активации
activateBtn.MouseButton1Click:Connect(function()
    activated = not activated
    
    if activated then
        activateBtn.Text = "⏹️ ОСТАНОВИТЬ"
        activateBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        startOrbitalAnimation()
        print("🌌 Cosmic Orbital активирован!")
    else
        activateBtn.Text = "✨ АКТИВИРОВАТЬ"
        activateBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 200)
        stopOrbitalAnimation()
        print("🌌 Cosmic Orbital - шары плавно парят в небеса...")
    end
end)

-- Авто-очистка при выходе
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        stopOrbitalAnimation()
        screenGui:Destroy()
    end
end)

-- Сообщение о загрузке
print("🌌 Cosmic Orbital Guardian загружен!")
print("✨ 4 радужных шара с плавным парением")
print("🕊️ Медленное и грациозное восхождение в небо")
print("💫 Нежный радужный взрыв на высоте")
print("🎮 Нажми R для активации/деактивации")

-- Горячая клавиша (R для активации/деактивации)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        activated = not activated
        
        if activated then
            activateBtn.Text = "⏹️ ОСТАНОВИТЬ"
            activateBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            startOrbitalAnimation()
        else
            activateBtn.Text = "✨ АКТИВИРОВАТЬ"
            activateBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 200)
            stopOrbitalAnimation()
        end
    end
end)
