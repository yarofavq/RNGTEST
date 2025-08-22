-- Phonk RNG Script using Rayfield UI by yarofav

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield', true))()
if not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source', true))()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local EquippedAura = LocalPlayer:WaitForChild("Equipped"):WaitForChild("Aura")
local Rolled = LocalPlayer:WaitForChild("Rolled")

-- Aura Sound
local AuraSoundFolder = LocalPlayer:FindFirstChild("AuraSound") or Instance.new("Folder", LocalPlayer)
AuraSoundFolder.Name = "AuraSound"
local AuraSound = AuraSoundFolder:FindFirstChild("AuraSound") or Instance.new("Sound", AuraSoundFolder)
AuraSound.Name = "AuraSound"

-- Variables
local AuraToggles = {}
local CurrentAura = nil
local LastCopiedAura = "None"
local AutoRollEnabled = false

-- UI Window
local Window = Rayfield:CreateWindow({
    Name = "🎵 Phonk RNG Script",
    LoadingTitle = "Phonk RNG Hub",
    LoadingSubtitle = "Made with Rayfield",
    KeySystem = false,
})

-- Tabs
local TabAuras = Window:CreateTab("Auras", 4483362458)
local TabGame = Window:CreateTab("Game", 4483362458)
local TabTools = Window:CreateTab("Tools", 4483362458)
local TabFun = Window:CreateTab("Fun", 4483362458)
local TabCopy = Window:CreateTab("Copy Aura", 4483362458)
local TabMusic = Window:CreateTab("Aura Music", 4483362458)

-- Functions
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

-- Copy Aura Tab
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

-- Button to give all players ProximityPrompt
TabCopy:CreateButton({Name="Give ProximityPrompt to All", Callback=function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local part = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local prompt = Instance.new("ProximityPrompt")
                prompt.ActionText = "Hold to copy aura"
                prompt.HoldDuration = 2
                prompt.Parent = part
                prompt.Triggered:Connect(function(plr)
                    if plr == LocalPlayer then
                        local equipped = player:FindFirstChild("Equipped")
                        if equipped and equipped:FindFirstChild("Aura") then
                            local auraValue = equipped.Aura.Value
                            EquippedAura.Value = auraValue
                            LastCopiedAura = auraValue
                            AuraStatus:Set("Last Copied Aura: "..LastCopiedAura)
                            Rayfield:Notify({Title="Copied", Content="Aura copied: "..auraValue, Duration=2})
                            for name, toggle in pairs(AuraToggles) do toggle:Set(name==auraValue) end
                        end
                    end
                end)
                game:GetService("Debris"):AddItem(prompt, 2)
            end
        end
    end
end})
