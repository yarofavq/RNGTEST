-- Phonk RNG Script with Loading Screen and Key System
local correctKey = "Ztag.inf"
local keyLink = "https://direct-link.net/1386295/x18O4Rt56sgl"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- === LOADING SCREEN ===
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGui"
loadingGui.ResetOnSpawn = false
loadingGui.Parent = PlayerGui

-- Background image
local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.Image = "rbxassetid://104976846876989"
bgImage.BackgroundTransparency = 1
bgImage.Parent = loadingGui

-- Loading Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 150)
frame.Position = UDim2.new(0.5, -200, 0.8, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.Parent = loadingGui
Instance.new("UICorner", frame)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Loading Script..."
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold

-- Progress bar background
local progressBg = Instance.new("Frame", frame)
progressBg.Size = UDim2.new(1, -40, 0, 20)
progressBg.Position = UDim2.new(0, 20, 0, 100)
progressBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
progressBg.BorderSizePixel = 0
Instance.new("UICorner", progressBg)

-- Progress bar
local progressBar = Instance.new("Frame", progressBg)
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
progressBar.BorderSizePixel = 0
Instance.new("UICorner", progressBar)

-- Percentage text
local percentage = Instance.new("TextLabel", frame)
percentage.Size = UDim2.new(1, 0, 0, 20)
percentage.Position = UDim2.new(0, 0, 0, 70)
percentage.BackgroundTransparency = 1
percentage.Text = "0%"
percentage.TextColor3 = Color3.new(1, 1, 1)
percentage.TextSize = 18
percentage.Font = Enum.Font.Gotham

-- Animate progress for 5 seconds
for i = 0, 100 do
    progressBar.Size = UDim2.new(i/100, 0, 1, 0)
    percentage.Text = i .. "%"
    task.wait(0.05) -- 5 seconds total
end

loadingGui:Destroy()

-- === KEY CHECK GUI ===
local function requestKey()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PhonkKeyGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 520, 0, 200)
    frame.Position = UDim2.new(0.5, -260, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    Instance.new("UICorner", frame)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.TextScaled = false
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Text = "Enter Key to Use Script"

    local info = Instance.new("TextLabel", frame)
    info.Size = UDim2.new(1, -20, 0, 48)
    info.Position = UDim2.new(0, 10, 0, 48)
    info.BackgroundTransparency = 1
    info.TextColor3 = Color3.new(1,1,1)
    info.TextWrapped = true
    info.Font = Enum.Font.Gotham
    info.TextSize = 14
    info.Text = "Get key at:\n" .. keyLink .. "\nPassword for archive is provided there."

    -- Copy Link button
    local copyLinkButton = Instance.new("TextButton", frame)
    copyLinkButton.Size = UDim2.new(0, 100, 0, 30)
    copyLinkButton.Position = UDim2.new(0, 10, 0, 100)
    copyLinkButton.Text = "Copy Link"
    copyLinkButton.Font = Enum.Font.Gotham
    copyLinkButton.TextSize = 14
    copyLinkButton.TextColor3 = Color3.new(1,1,1)
    copyLinkButton.BackgroundColor3 = Color3.fromRGB(70,130,180)
    Instance.new("UICorner", copyLinkButton)

    local inputBox = Instance.new("TextBox", frame)
    inputBox.Size = UDim2.new(1, -120, 0, 32)
    inputBox.Position = UDim2.new(0, 10, 0, 140)
    inputBox.PlaceholderText = "Enter key here"
    inputBox.ClearTextOnFocus = false
    inputBox.Text = ""
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 18
    inputBox.TextColor3 = Color3.new(1,1,1)
    inputBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", inputBox)

    local submit = Instance.new("TextButton", frame)
    submit.Size = UDim2.new(0, 90, 0, 32)
    submit.Position = UDim2.new(1, -100, 0, 140)
    submit.Text = "Submit"
    submit.Font = Enum.Font.GothamBold
    submit.TextSize = 18
    submit.TextColor3 = Color3.new(1,1,1)
    submit.BackgroundColor3 = Color3.fromRGB(70,130,180)
    Instance.new("UICorner", submit)

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1, -20, 0, 14)
    status.Position = UDim2.new(0, 10, 0, 176)
    status.BackgroundTransparency = 1
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Font = Enum.Font.Gotham
    status.TextSize = 13
    status.Text = "Enter the key and press Submit."

    local keyAccepted = false

    local function checkKey(k)
        if k == correctKey then
            keyAccepted = true
            screenGui:Destroy()
            return true
        else
            status.Text = "Incorrect key. Get key at: " .. keyLink
            inputBox.Text = ""
            return false
        end
    end

    -- Copy link functionality
    copyLinkButton.MouseButton1Click:Connect(function()
        setclipboard(keyLink)
        status.Text = "Link copied to clipboard!"
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

requestKey()

-- После прохождения проверки — тут твой основной скрипт!
print("Key correct! Script loaded.")
