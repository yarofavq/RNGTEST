-- Полный скрипт Phonk RNG с Rayfield UI, аурами, музыкой, автороллом, инструментами, ESP, радужным телом, кредитами и блюром

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")

-- ===== Ключ и загрузка =====
local correctKey = "Ztag.inf"
local keyLink = "https://direct-link.net/1386295/x18O4Rt56sgl"
local loadingImageId = "rbxassetid://104976846876989"

-- Blur для ключа
local blur = Instance.new("BlurEffect")
blur.Name = "PhonkKeyBlur"
blur.Size = 24
blur.Parent = Lighting

-- GUI для проверки ключа
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PhonkKeyGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1,0,1,0)
bg.Position = UDim2.new(0,0,0,0)
bg.BackgroundTransparency = 1
bg.Image = loadingImageId
bg.Parent = screenGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,520,0,200)
frame.Position = UDim2.new(0.5,-260,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,-20,0,40)
title.Position = UDim2.new(0,10,0,10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Text = "Enter Key to Use Script"

local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(1,-140,0,32)
inputBox.Position = UDim2.new(0,140,0,108)
inputBox.PlaceholderText = "Enter key here"
inputBox.ClearTextOnFocus = false
inputBox.Text = ""
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 18
inputBox.TextColor3 = Color3.new(1,1,1)
inputBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner", inputBox)

local submit = Instance.new("TextButton", frame)
submit.Size = UDim2.new(0,90,0,32)
submit.Position = UDim2.new(1,-100,0,108)
submit.Text = "Submit"
submit.Font = Enum.Font.GothamBold
submit.TextSize = 18
submit.TextColor3 = Color3.new(1,1,1)
submit.BackgroundColor3 = Color3.fromRGB(70,130,180)
Instance.new("UICorner", submit)

local copyLinkButton = Instance.new("TextButton", frame)
copyLinkButton.Size = UDim2.new(0,120,0,30)
copyLinkButton.Position = UDim2.new(0,10,0,108)
copyLinkButton.Text = "Copy Key Link"
copyLinkButton.Font = Enum.Font.Gotham
copyLinkButton.TextSize = 14
copyLinkButton.TextColor3 = Color3.new(1,1,1)
copyLinkButton.BackgroundColor3 = Color3.fromRGB(70,130,180)
Instance.new("UICorner", copyLinkButton)
copyLinkButton.MouseButton1Click:Connect(function()
    setclipboard(keyLink)
end)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,-20,0,20)
status.Position = UDim2.new(0,10,0,150)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(200,200,200)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.Text = "Enter key and press Submit."

local progressBar = Instance.new("Frame", frame)
progressBar.Size = UDim2.new(0,0,0,10)
progressBar.Position = UDim2.new(0,10,0,180)
progressBar.BackgroundColor3 = Color3.fromRGB(70,130,180)
Instance.new("UICorner", progressBar)

local keyAccepted = false
local function checkKey(k)
    if k == correctKey then
        keyAccepted = true
        for i = 0,1,0.01 do
            progressBar.Size = UDim2.new(i,0,0,10)
            status.Text = "Loading... "..math.floor(i*100).."%"
            task.wait(0.02)
        end
        screenGui:Destroy()
        blur:Destroy()
    else
        status.Text = "Incorrect key."
        inputBox.Text = ""
    end
end

submit.MouseButton1Click:Connect(function() checkKey(inputBox.Text) end)
inputBox.FocusLost:Connect(function(enterPressed) if enterPressed then checkKey(inputBox.Text) end end)
repeat task.wait() until keyAccepted

-- ===== Rayfield UI и основной скрипт =====
local Rayfield = nil
local ok,_ = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield', true))()
end)
if not ok or not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source', true))()
end

local EquippedAura = LocalPlayer:WaitForChild("Equipped"):WaitForChild("Aura")
local Rolled = LocalPlayer:WaitForChild("Rolled")
local AuraSoundFolder = LocalPlayer:FindFirstChild("AuraSound") or Instance.new("Folder", LocalPlayer)
AuraSoundFolder.Name = "AuraSound"
local AuraSound = AuraSoundFolder:FindFirstChild("AuraSound") or Instance.new("Sound", AuraSoundFolder)
AuraSound.Name = "AuraSound"
AuraSound.Looped = true
AuraSound.Volume = 0.5

local AuraToggles = {}
local CurrentAura = nil
local LastCopiedAura = "None"
local AutoRollEnabled = false

local Window = Rayfield:CreateWindow({Name="🎵 Phonk RNG Script",LoadingTitle="Phonk RNG Hub",LoadingSubtitle="Made with Rayfield",KeySystem=false})
local TabAuras = Window:CreateTab("Auras",4483362458)
local TabGame = Window:CreateTab("Game",4483362458)
local TabTools = Window:CreateTab("Tools",4483362458)
local TabFun = Window:CreateTab("Fun",4483362458)
local TabCopy = Window:CreateTab("Copy Aura",4483362458)
local TabMusic = Window:CreateTab("Aura Music",4483362458)
local TabCreds = Window:CreateTab("Credits",4483362458)

-- ===== Кредиты с блюром =====
local CreditsGui = Instance.new("ScreenGui")
CreditsGui.Name = "PhonkCredits"
CreditsGui.ResetOnSpawn = false
CreditsGui.IgnoreGuiInset = true
CreditsGui.Enabled = false
CreditsGui.Parent = PlayerGui

local blurCreds = Instance.new("BlurEffect")
blurCreds.Name = "PhonkCreditsBlur"
blurCreds.Size = 20
blurCreds.Parent = Lighting

local bgCreds = Instance.new("Frame")
bgCreds.Size = UDim2.fromScale(1,1)
bgCreds.BackgroundColor3 = Color3.new(0,0,0)
bgCreds.BackgroundTransparency = 0.3
bgCreds.Parent = CreditsGui

local titleCreds = Instance.new("TextLabel")
titleCreds.Size = UDim2.new(1,0,0,50)
titleCreds.Position = UDim2.new(0,0,0,10)
titleCreds.BackgroundTransparency = 1
titleCreds.TextColor3 = Color3.new(1,1,1)
titleCreds.Font = Enum.Font.GothamBlack
titleCreds.TextSize = 36
titleCreds.Text = "Script Credits"
titleCreds.Parent = bgCreds

-- Ваши кредиты (можно добавить больше)
local function addCredit(displayName, handle, userId)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,400,0,100)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BackgroundTransparency = 0.1
    frame.Parent = bgCreds

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0,200,0,30)
    nameLbl.Position = UDim2.new(0,10,0,10)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Color3.new(1,1,1)
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 20
    nameLbl.Text = displayName
    nameLbl.Parent = frame

    local handleLbl = Instance.new("TextLabel")
    handleLbl.Size = UDim2.new(0,200,0,20)
    handleLbl.Position = UDim2.new(0,10,0,40)
    handleLbl.BackgroundTransparency = 1
    handleLbl.TextColor3 = Color3.new(0.8,0.8,0.8)
    handleLbl.Font = Enum.Font.Gotham
    handleLbl.TextSize = 16
    handleLbl.Text = "@"..handle
    handleLbl.Parent = frame
end

addCredit("Str1k3rXxX","Str1k3rXxX",8565924427)
addCredit("VaBlox","ValeraStar_2008",1)

TabCreds:CreateToggle({Name="Show Credits Overlay",CurrentValue=false,Callback=function(state)
    CreditsGui.Enabled = state
    if state then blurCreds.Enabled = true else blurCreds.Enabled = false end
end})
