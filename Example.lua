-- 1. Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/r1nhubdev/R1n/main/LowyxUI.lua"))()

-- 2. Create the window
local Window = Library:CreateWindow({
    Title = "Lowyx Hub",
    SearchPlaceholder = "Find a tab...",
    DiscordLink = "discord.gg/lowyx",
})

-- 3. Tabs
local MainTab = Window:CreateTab({
    Title = "Main",
    Icon = "rbxassetid://10747373176",
})

local InfoTab = Window:CreateTab({
    Title = "Info",
    Icon = "rbxassetid://10723424505",
})

-- 4. Sections
local CombatSection = MainTab:CreateSection({
    Title = "Combat",
    Side = "Left",
    Icon = "rbxassetid://10747373176",
})

local MovementSection = MainTab:CreateSection({
    Title = "Movement",
    Side = "Right",
    Icon = "rbxassetid://10723346959",
})

local AboutSection = InfoTab:CreateSection({
    Title = "About",
    Side = "Left",
    Icon = "rbxassetid://10723424505",
})

-- 5. Components
local AutoAttack = CombatSection:CreateToggle({
    Title = "Auto Attack",
    Default = false,
    Callback = function(enabled)
        Window:Notify("Auto Attack: " .. (enabled and "ON" or "OFF"))
    end,
})

local AttackRange = CombatSection:CreateSlider({
    Title = "Attack Range",
    Min = 5,
    Max = 50,
    Increment = 1,
    Default = 15,
    Callback = function(value)
        Window:Notify("Attack Range: " .. value .. " studs")
    end,
})

local TeleportTo = MovementSection:CreateDropdown({
    Title = "Teleport To",
    Options = {"Hospital", "Docks", "Museum", "Police"},
    Callback = function(option)
        Window:Notify("Selected: " .. tostring(option))
    end,
})

local PlayerName = MovementSection:CreateInput({
    Title = "Player Name",
    Placeholder = "Username...",
    Callback = function(text)
        Window:Notify("Target: " .. text)
    end,
})

MovementSection:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        Window:Notify("Rejoin clicked")
    end,
})

AboutSection:CreateComment({
    Text = "Version 1.0 - Lowyx Hub",
})

AboutSection:CreateLargeText({
    Text = "Welcome to Lowyx Hub! Use the Main tab to configure combat and movement. Press Left Ctrl or the floating button to hide the window.",
})

-- Reading values later:
-- AutoAttack:GetValue()   AttackRange:GetValue()   TeleportTo:GetValue()   PlayerName:GetValue()
