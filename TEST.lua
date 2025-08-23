-- Phonk RNG Script using Rayfield UI by yarofav
-- Key check (link only, no password exposed)
local correctKey = "Ztag.inf" -- не отображается пользователю
local keyLink    = "https://direct-link.net/1386295/x18O4Rt56sgl"
local loadingImageId = "rbxassetid://104976846876989"

local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Lighting    = game:GetService("Lighting")

---------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------
local function safeDestroy(obj) if obj and obj.Destroy then pcall(function() obj:Destroy() end) end end

local function makeFullImage(parent, imageId, z)
    local img = Instance.new("ImageLabel")
    img.Name = "FullBG"
    img.BackgroundTransparency = 1
    img.Size = UDim2.fromScale(1,1)
    img.Position = UDim2.fromScale(0,0)
    img.Image = imageId
    img.ScaleType = Enum.ScaleType.Crop
    img.ZIndex = z or 0
    img.Parent = parent
    return img
end

local function addUICorner(inst, radius)
    local uic = Instance.new("UICorner")
    if radius then uic.CornerRadius = UDim.new(0, radius) end
    uic.Parent = inst
    return uic
end

---------------------------------------------------------------------
-- Key UI (draggable) + game blur + BG image
---------------------------------------------------------------------
local function requestKey()
    -- Blur ON
    local blur = Instance.new("BlurEffect")
    blur.Name = "PhonkKeyBlur"
    blur.Size = 24
    blur.Parent = Lighting

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PhonkKeyGui"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = PlayerGui

    -- Fullscreen background image
    makeFullImage(screenGui, loadingImageId, 0)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 520, 0, 160)
    frame.Position = UDim2.new(0.5, -260, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    frame.Active = true
    frame.Draggable = true -- перетаскиваемое окно
    frame.Parent = screenGui
    addUICorner(frame, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.ZIndex = 3
    title.Text = "Enter Key to Use Script"
    title.Parent = frame

    -- Подсказка без показа пароля
    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -20, 0, 18)
    hint.Position = UDim2.new(0, 10, 0, 50)
    hint.BackgroundTransparency = 1
    hint.TextColor3 = Color3.fromRGB(210,210,210)
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 14
    hint.ZIndex = 3
    hint.Text = "Get key: press the button below"
    hint.Parent = frame

    -- Кнопка копирования ссылки
    local copyLinkButton = Instance.new("TextButton")
    copyLinkButton.Size = UDim2.new(0, 140, 0, 30)
    copyLinkButton.Position = UDim2.new(0, 10, 0, 80)
    copyLinkButton.Text = "Copy Key Link"
    copyLinkButton.Font = Enum.Font.Gotham
    copyLinkButton.TextSize = 14
    copyLinkButton.TextColor3 = Color3.new(1,1,1)
    copyLinkButton.BackgroundColor3 = Color3.fromRGB(70,130,180)
    copyLinkButton.ZIndex = 3
    copyLinkButton.Parent = frame
    addUICorner(copyLinkButton, 8)

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -170, 0, 32)
    inputBox.Position = UDim2.new(0, 160, 0, 78)
    inputBox.PlaceholderText = "Enter key here"
    inputBox.ClearTextOnFocus = false
    inputBox.Text = ""
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 18
    inputBox.TextColor3 = Color3.new(1,1,1)
    inputBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
    inputBox.ZIndex = 3
    inputBox.Parent = frame
    addUICorner(inputBox, 8)

    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0, 90, 0, 32)
    submit.Position = UDim2.new(1, -100, 0, 120)
    submit.Text = "Submit"
    submit.Font = Enum.Font.GothamBold
    submit.TextSize = 18
    submit.TextColor3 = Color3.new(1,1,1)
    submit.BackgroundColor3 = Color3.fromRGB(70,130,180)
    submit.ZIndex = 3
    submit.Parent = frame
    addUICorner(submit, 8)

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 122)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Font = Enum.Font.Gotham
    status.TextSize = 13
    status.ZIndex = 3
    status.Text = "Enter the key and press Submit."
    status.Parent = frame

    local keyAccepted = false

    local function checkKey(k)
        if k == correctKey then
            keyAccepted = true
            -- Blur OFF
            safeDestroy(blur)
            safeDestroy(screenGui)
            return true
        else
            status.Text = "Incorrect key. Use the key link."
            inputBox.Text = ""
            return false
        end
    end

    copyLinkButton.MouseButton1Click:Connect(function()
        setclipboard(keyLink)
        status.Text = "Key link copied to clipboard!"
    end)

    submit.MouseButton1Click:Connect(function()
        checkKey(inputBox.Text)
    end)

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            checkKey(inputBox.Text)
        end
    end)

    repeat task.wait() until keyAccepted
end

---------------------------------------------------------------------
-- Loading screen with progress (5s) + fullscreen image
---------------------------------------------------------------------
local function showLoading(seconds)
    seconds = seconds or 5
    local gui = Instance.new("ScreenGui")
    gui.Name = "PhonkLoading"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    -- BG image
    makeFullImage(gui, loadingImageId, 0)

    -- Dark veil
    local veil = Instance.new("Frame")
    veil.BackgroundColor3 = Color3.new(0,0,0)
    veil.BackgroundTransparency = 0.35
    veil.Size = UDim2.fromScale(1,1)
    veil.ZIndex = 1
    veil.Parent = gui

    -- Centered Progress
    local progressLabel = Instance.new("TextLabel")
    progressLabel.AnchorPoint = Vector2.new(0.5,0.5)
    progressLabel.Position = UDim2.fromScale(0.5,0.6)
    progressLabel.Size = UDim2.new(0, 300, 0, 60)
    progressLabel.BackgroundTransparency = 0.15
    progressLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
    progressLabel.TextColor3 = Color3.new(1,1,1)
    progressLabel.Font = Enum.Font.GothamBlack
    progressLabel.TextSize = 32
    progressLabel.Text = "0%"
    progressLabel.ZIndex = 3
    progressLabel.Parent = gui
    addUICorner(progressLabel, 12)

    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5,0.5)
    title.Position = UDim2.fromScale(0.5,0.45)
    title.Size = UDim2.new(0, 420, 0, 50)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.Text = "Loading Phonk RNG..."
    title.ZIndex = 3
    title.Parent = gui

    -- Progress loop (~5s)
    local steps = 100
    local delayPer = seconds / steps
    for i = 0, steps do
        progressLabel.Text = tostring(i) .. "%"
        task.wait(delayPer)
    end

    safeDestroy(gui)
end

---------------------------------------------------------------------
-- Start: Key → Loading → Main
---------------------------------------------------------------------
requestKey()
showLoading(5)

---------------------------------------------------------------------
-- Load Rayfield
---------------------------------------------------------------------
local Rayfield = nil
local ok, _err = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield', true))()
end)
if not ok or not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source', true))()
end

---------------------------------------------------------------------
-- Game data
---------------------------------------------------------------------
local StarterGui   = game:GetService("StarterGui")
local EquippedAura = LocalPlayer:WaitForChild("Equipped"):WaitForChild("Aura")
local Rolled       = LocalPlayer:WaitForChild("Rolled")

-- Aura Sound folder & sound
local AuraSoundFolder = LocalPlayer:FindFirstChild("AuraSound") or Instance.new("Folder", LocalPlayer)
AuraSoundFolder.Name = "AuraSound"
local AuraSound = AuraSoundFolder:FindFirstChild("AuraSound") or Instance.new("Sound", AuraSoundFolder)
AuraSound.Name = "AuraSound"
AuraSound.Looped = true
AuraSound.Volume = 0.5

-- Variables
local AuraToggles = {}
local CurrentAura = nil
local LastCopiedAura = "None"
local AutoRollEnabled = false

---------------------------------------------------------------------
-- Window & Tabs (includes Credits tab)
---------------------------------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "🎵 Phonk RNG Script",
    LoadingTitle = "Phonk RNG Hub",
    LoadingSubtitle = "Made with Rayfield",
    KeySystem = false,
})

local TabAuras = Window:CreateTab("Auras", 4483362458)
local TabGame  = Window:CreateTab("Game", 4483362458)
local TabTools = Window:CreateTab("Tools", 4483362458)
local TabFun   = Window:CreateTab("Fun", 4483362458)
local TabCopy  = Window:CreateTab("Copy Aura", 4483362458)
local TabMusic = Window:CreateTab("Aura Music", 4483362458)
local TabCreds = Window:CreateTab("Credits", 4483362458)

---------------------------------------------------------------------
-- Credits Overlay (neon rainbow) with avatars
---------------------------------------------------------------------
local function createCreditsGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "PhonkCredits"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Enabled = false
    gui.Parent = PlayerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1,1)
    bg.Position = UDim2.fromScale(0,0)
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local grad = Instance.new("UIGradient")
    grad.Rotation = 0
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 128)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
    }
    grad.Offset = Vector2.new(0,0)
    grad.Parent = bg

    -- animate gradient offset
    task.spawn(function()
        local t = 0
        while gui.Parent do
            t += 0.005
            grad.Offset = Vector2.new(math.sin(t)*0.5, math.cos(t*0.8)*0.5)
            task.wait(0.016)
        end
    end)

    -- Dark veil for readability
    local veil = Instance.new("Frame")
    veil.BackgroundColor3 = Color3.new(0,0,0)
    veil.BackgroundTransparency = 0.35
    veil.Size = UDim2.fromScale(1,1)
    veil.Parent = bg

    -- Title
    local title = Instance.new("TextLabel")
    title.AnchorPoint = Vector2.new(0.5,0)
    title.Position = UDim2.fromScale(0.5,0.08)
    title.Size = UDim2.new(0, 500, 0, 48)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 36
    title.Text = "Script Credits"
    title.Parent = bg

    -- Container for cards
    local container = Instance.new("Frame")
    container.AnchorPoint = Vector2.new(0.5,0.5)
    container.Position = UDim2.fromScale(0.5,0.55)
    container.Size = UDim2.new(0, 800, 0, 300)
    container.BackgroundTransparency = 1
    container.Parent = bg

    local uiList = Instance.new("UIListLayout")
    uiList.FillDirection = Enum.FillDirection.Horizontal
    uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiList.VerticalAlignment = Enum.VerticalAlignment.Center
    uiList.Padding = UDim.new(0, 24)
    uiList.Parent = container

    local function makeCard(displayName, handle, userId)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(0, 360, 0, 220)
        card.BackgroundColor3 = Color3.fromRGB(22,22,22)
        card.BackgroundTransparency = 0.1
        addUICorner(card, 16)
        card.Parent = container

        local avatar = Instance.new("ImageLabel")
        avatar.BackgroundTransparency = 1
        avatar.Size = UDim2.new(0, 128, 0, 128)
        avatar.Position = UDim2.new(0, 24, 0, 24)
        avatar.Parent = card

        -- avatar fetch
        task.spawn(function()
            local okThumb, content = pcall(function()
                return Players:GetUserThumbnailAsync(tonumber(userId) or 1, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            if okThumb and content then avatar.Image = content end
        end)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Position = UDim2.new(0, 170, 0, 36)
        nameLbl.Size = UDim2.new(0, 170, 0, 36)
        nameLbl.BackgroundTransparency = 1
        nameLbl.TextColor3 = Color3.new(1,1,1)
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 22
        nameLbl.Text = displayName
        nameLbl.Parent = card

        local handleLbl = Instance.new("TextLabel")
        handleLbl.Position = UDim2.new(0, 170, 0, 74)
        handleLbl.Size = UDim2.new(0, 170, 0, 24)
        handleLbl.BackgroundTransparency = 1
        handleLbl.TextColor3 = Color3.fromRGB(200,200,200)
        handleLbl.TextXAlignment = Enum.TextXAlignment.Left
        handleLbl.Font = Enum.Font.Gotham
        handleLbl.TextSize = 16
        handleLbl.Text = "@"..tostring(handle)
        handleLbl.Parent = card

        return card, avatar, nameLbl, handleLbl
    end

    -- You
    local myCard = makeCard("Str1k3rXxX", "Str1k3rXxX", 8565924427)

    -- Friend (placeholder, will be filled from Tab input)
    local friendCard, friendAvatar, friendNameLbl, friendHandleLbl = makeCard("VaBlox", "ValeraStar_2008", 1)
    friendCard.Name = "FriendCard"

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.AnchorPoint = Vector2.new(0.5,1)
    closeBtn.Position = UDim2.fromScale(0.5,0.95)
    closeBtn.Size = UDim2.new(0, 150, 0, 36)
    closeBtn.Text = "Close"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.BackgroundColor3 = Color3.fromRGB(70,130,180)
    addUICorner(closeBtn, 10)
    closeBtn.Parent = bg

    closeBtn.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    -- updater returned
    local function updateFriend(uid)
        uid = tonumber(uid)
        if not uid then return end
        task.spawn(function()
            local uname = nil
            pcall(function() uname = Players:GetNameFromUserIdAsync(uid) end)
            if uname then
                friendNameLbl.Text = uname
                friendHandleLbl.Text = "@"..uname
            end
            local okThumb, content = pcall(function()
                return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            if okThumb and content then friendAvatar.Image = content end
        end)
    end

    return gui, updateFriend
end

local CreditsGui, UpdateFriendAvatar = createCreditsGui()

-- Tab "Credits" controls
TabCreds:CreateParagraph({Title="Credits Overlay", Content="Show a neon rainbow overlay with avatars. Your ID is preset. Enter your friend's UserId to add them."})
TabCreds:CreateInput({
    Name = "Friend UserId",
    PlaceholderText = "Enter friend's Roblox UserId",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt)
        if UpdateFriendAvatar then UpdateFriendAvatar(txt) end
    end
})
TabCreds:CreateToggle({
    Name = "Show Credits Overlay",
    CurrentValue = false,
    Callback = function(state)
        if CreditsGui then CreditsGui.Enabled = state end
    end
})

---------------------------------------------------------------------
-- Auras list & controls
---------------------------------------------------------------------
local function ResetAuras()
    for _, toggle in pairs(AuraToggles) do
        if toggle and toggle.Set then toggle:Set(false) end
    end
    CurrentAura = nil
end

local function RebuildAuraList()
    for _, toggle in pairs(AuraToggles) do
        if toggle and toggle.Destroy then toggle:Destroy() end
    end
    AuraToggles = {}

    local numericAuras, stringAuras = {}, {}
    for _, item in ipairs(Rolled:GetChildren()) do
        local name = item.Name
        if tonumber(name:match("%d+")) then
            table.insert(numericAuras, name)
        else
            table.insert(stringAuras, name)
        end
    end

    table.sort(numericAuras)
    table.sort(stringAuras)

    local finalList = {}
    for _, v in ipairs(numericAuras) do table.insert(finalList, v) end
    for _, v in ipairs(stringAuras) do table.insert(finalList, v) end

    for _, name in ipairs(finalList) do
        local Toggle = TabAuras:CreateToggle({
            Name = name,
            CurrentValue = (EquippedAura.Value == name),
            Callback = function(state)
                if state then
                    for otherName, otherToggle in pairs(AuraToggles) do
                        if otherName ~= name then otherToggle:Set(false) end
                    end
                    CurrentAura = name
                    EquippedAura.Value = name
                    AuraSound:Stop()
                    Rayfield:Notify({Title = "Aura Selected", Content = "Equipped: "..name, Duration = 2})
                else
                    if CurrentAura == name then
                        CurrentAura = nil
                        EquippedAura.Value = ""
                    end
                end
            end
        })
        AuraToggles[name] = Toggle
    end
end

RebuildAuraList()
Rolled.ChildAdded:Connect(RebuildAuraList)
Rolled.ChildRemoved:Connect(RebuildAuraList)

---------------------------------------------------------------------
-- Copy Aura
---------------------------------------------------------------------
TabCopy:CreateParagraph({Title = "Copy Aura Info", Content = "Type a player's name to copy their aura or hold for 2 seconds"})
local AuraStatus = TabCopy:CreateLabel("Last Copied Aura: "..LastCopiedAura)

TabCopy:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Example: Player1",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        local target
        for _, p in pairs(Players:GetPlayers()) do
            if string.find(p.Name:lower(), input:lower()) then target = p break end
        end
        if target then
            local equipped = target:FindFirstChild("Equipped")
            if equipped and equipped:FindFirstChild("Aura") then
                local auraValue = equipped.Aura.Value
                EquippedAura.Value = auraValue
                LastCopiedAura = auraValue
                AuraStatus:Set("Last Copied Aura: "..LastCopiedAura)
                Rayfield:Notify({Title="Copied", Content="Aura copied: "..auraValue, Duration=2})
                for name, toggle in pairs(AuraToggles) do toggle:Set(name==auraValue) end
            else
                Rayfield:Notify({Title="Error", Content="Target has no Aura.", Duration=2})
            end
        else
            Rayfield:Notify({Title="Error", Content="Player not found.", Duration=2})
        end
    end
})

TabCopy:CreateButton({Name="Enable Proximity Aura", Callback=function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local prompt = Instance.new("ProximityPrompt")
            prompt.Name = "PhonkCopyPrompt"
            prompt.ActionText = "Hold to Copy Aura"
            prompt.ObjectText = player.Name
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 8
            prompt.HoldDuration = 2
            prompt.Parent = hrp

            prompt.Triggered:Connect(function(plr)
                if plr == LocalPlayer then
                    local equipped = player:FindFirstChild("Equipped")
                    if equipped and equipped:FindFirstChild("Aura") then
                        local auraValue = equipped.Aura.Value
                        EquippedAura.Value = auraValue
                        LastCopiedAura = auraValue
                        AuraStatus:Set("Last Copied Aura: "..LastCopiedAura)
                        Rayfield:Notify({Title="Copied via Proximity", Content="Aura copied: "..auraValue, Duration=2})
                        for name, toggle in pairs(AuraToggles) do toggle:Set(name==auraValue) end
                    end
                end
            end)

            game:GetService("Debris"):AddItem(prompt, 6)
        end
    end
end})

---------------------------------------------------------------------
-- Game Tab
---------------------------------------------------------------------
TabGame:CreateButton({Name="Teleport to Charm 1", Callback=function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if char.PrimaryPart == nil then
        char:WaitForChild("HumanoidRootPart")
        char.PrimaryPart = char:FindFirstChild("HumanoidRootPart")
    end
    char:SetPrimaryPartCFrame(CFrame.new(93.9420929,206.313431,-362.343933,1,0,0,0,1,0,0,0,1))
    Rayfield:Notify({Title="Teleported", Content="Teleported to Charm 1", Duration=2})
end})

TabGame:CreateButton({Name="Teleport to Charm 2", Callback=function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if char.PrimaryPart == nil then
        char:WaitForChild("HumanoidRootPart")
        char.PrimaryPart = char:FindFirstChild("HumanoidRootPart")
    end
    char:SetPrimaryPartCFrame(CFrame.new(-191.257889,206.213348,-352.611938,1,0,0,0,1,0,0,0,1))
    Rayfield:Notify({Title="Teleported", Content="Teleported to Charm 2", Duration=2})
end})

TabGame:CreateToggle({Name="Auto Roll", CurrentValue=false, Callback=function(state)
    AutoRollEnabled = state
    Rayfield:Notify({Title="Auto Roll", Content=(state and "Enabled" or "Disabled"), Duration=2})
    task.spawn(function()
        while AutoRollEnabled do
            local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui and playerGui:FindFirstChild("MainGui") then
                pcall(function()
                    playerGui:WaitForChild("MainGui"):WaitForChild("Rolling"):WaitForChild("Rolling"):FireServer(true)
                end)
            end
            task.wait(0.1)
        end
    end)
end})

---------------------------------------------------------------------
-- Tools
---------------------------------------------------------------------
TabTools:CreateButton({Name="Load Infinite Yield", Callback=function()
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua'))()
    end)
    Rayfield:Notify({Title="Loaded", Content="Infinite Yield executed.", Duration=2})
end})

TabTools:CreateButton({Name="Copy Place ID", Callback=function()
    setclipboard(tostring(game.PlaceId))
    Rayfield:Notify({Title="Copied", Content="Place ID copied.", Duration=2})
end})

TabTools:CreateButton({Name="Copy Your User ID", Callback=function()
    setclipboard(tostring(LocalPlayer.UserId))
    Rayfield:Notify({Title="Copied", Content="User ID copied.", Duration=2})
end})

---------------------------------------------------------------------
-- Fun
---------------------------------------------------------------------
TabFun:CreateToggle({Name="Rainbow Body", CurrentValue=false, Callback=function(state)
    task.spawn(function()
        while state do
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Color = Color3.fromHSV((tick()%5)/5,1,1)
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end})

TabFun:CreateToggle({Name="ESP (Highlight Players)", CurrentValue=false, Callback=function(state)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if state then
                local char = player.Character or player.CharacterAdded:Wait()
                if not char:FindFirstChild("PhonkESP_Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "PhonkESP_Highlight"
                    highlight.FillColor = Color3.new(1, 0, 0)
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.Parent = char
                end
            else
                if player.Character and player.Character:FindFirstChild("PhonkESP_Highlight") then
                    player.Character.PhonkESP_Highlight:Destroy()
                end
            end
        end
    end
end})

---------------------------------------------------------------------
-- Aura Music
---------------------------------------------------------------------
local musicList = {
    {Name="BRR BRR PATAPIM", ID="83630219580953"},
    {Name="Brainz Funk", ID="70586618643318"},
    {Name="City Lightz Pr Funk", ID="81068115852250"},
    {Name="Funk Diamante Enigma", ID="113208690604605"},
    {Name="Goth Funk", ID="140704128008979"},
    {Name="Nadie Sale de Aqui Funk", ID="95480320349659"},
    {Name="Atmospherika Funk", ID="136295506080844"},
    {Name="Bankai Funk", ID="129078347843179"},
    {Name="Above Phonk", ID="89824897586105"}
}

TabMusic:CreateParagraph({Title="Note", Content="Some tracks may not work due to copyright restrictions"})

for _, track in ipairs(musicList) do
    TabMusic:CreateButton({Name=track.Name, Callback=function()
        AuraSound.SoundId = "rbxassetid://" .. track.ID
        AuraSound:Play()
        EquippedAura.Value = ""
    end})
end

TabMusic:CreateInput({Name="Custom Sound ID", PlaceholderText="Enter Roblox Sound ID", RemoveTextAfterFocusLost=false, Callback=function(id)
    if tonumber(id) then
        AuraSound.SoundId = "rbxassetid://" .. id
        AuraSound:Play()
        EquippedAura.Value = ""
    end
end})
