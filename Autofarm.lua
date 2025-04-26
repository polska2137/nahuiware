local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Nahuiware",
    Icon = 0,
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Tadano3310",
    Theme = "Bloom",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "Big Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
    }
})

Rayfield:Notify({
    Title = "Nahuiware",
    Content = "Thank you for using my script!",
    Duration = 6.5,
    Image = 4483362458,
})

local MainTab = Window:CreateTab("AutoFarm", 4483362458)
local MainSection = MainTab:CreateSection("Money")

local farming = false
local farmThread

local MainToggle = MainTab:CreateToggle({
    Name = "Autofarm Money",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        farming = Value
        if farming then
            farmThread = task.spawn(function()
                while farming do
                    local args = {
                        "MadeVideoManually"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_3"):FireServer(unpack(args))
                    task.wait(0)
                end
            end)
        else
            if farmThread then
                task.cancel(farmThread)
            end
        end
    end,
})

local AutoTab = Window:CreateTab("Upgrades", 4483362458)
local AutoSection = AutoTab:CreateSection("Auto Upgrade")

local upgrading = false
local upgradeThread

local AutoToggle = AutoTab:CreateToggle({
    Name = "Auto upgrade Wifi speed",
    CurrentValue = false,
    Flag = "Toggle2",
    Callback = function(Value)
        upgrading = Value
        if upgrading then
            upgradeThread = task.spawn(function()
                while upgrading do
                    local args = {
                        "Upgrade",
                        "Wifi"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_4"):FireServer(unpack(args))
                    task.wait(0)
                end
            end)
        else
            if upgradeThread then
                task.cancel(upgradeThread)
            end
        end
    end,
})

local upgradingVideo = false
local upgradeVideoThread

local AutoToggle = AutoTab:CreateToggle({
    Name = "Auto upgrade Video quality",
    CurrentValue = false,
    Flag = "Toggle3",
    Callback = function(Value)
        upgradingVideo = Value
        if upgradingVideo then
            upgradeVideoThread = task.spawn(function()
                while upgradingVideo do
                    local args = {
                        "Upgrade",
                        "ManualRev"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_3"):FireServer(unpack(args))
                    task.wait(0)
                end
            end)
        else
            if upgradeVideoThread then
                task.cancel(upgradeVideoThread)
            end
        end
    end,
})

local upgradingFriend = false
local upgradeFriendThread

local AutoToggle= AutoTab:CreateToggle({
    Name = "Auto upgrade Friend Management",
    CurrentValue = false,
    Flag = "Toggle4",
    Callback = function(Value)
        upgradingFriend = Value
        if upgradingFriend then
            upgradeFriendThread = task.spawn(function()
                while upgradingFriend do
                    local args = {
                        "Upgrade",
                        "FriendRev"
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent_1"):FireServer(unpack(args))
                    task.wait(0)
                end
            end)
        else
            if upgradeFriendThread then
                task.cancel(upgradeFriendThread)
            end
        end
    end,
})
