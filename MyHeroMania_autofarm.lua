local ui = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))().Load({
	Title = "My Hero Mania",
	Style = 1,
	SizeX = 300,
	SizeY = 300,
	Theme = "Dark",
})

local heartbeat = game:GetService("RunService").Heartbeat
local opts = {}
local player = game:GetService("Players").LocalPlayer
local functions = {}

local tab1 = ui.New({Title = "Main"})
local tab2 = ui.New({Title = "Misc"})

tab1.Dropdown({
    Text = "Target",
    Callback = function(opt)
        opts.questgiver, opts.mob = opt, game:GetService("ReplicatedStorage").Package.Quests[opt].Target.Value
    end,
    Options = (function()
        local quests = {}
        for i,v in pairs(game:GetService("ReplicatedStorage").Package.Quests:GetChildren()) do
            table.insert(quests, v.Name)
        end
        return quests
    end)()
})

tab1.Toggle({
    Text = "Autofarm",
    Callback = function(bool)
        opts.farm = bool
        while opts.farm and heartbeat:wait() do
            if not player.PlayerGui.HUD.Frames.Quest.Visible then
                game:GetService("ReplicatedStorage").Package.Events.GetQuest:InvokeServer(opts.questgiver)
                player.PlayerGui.HUD.Frames.Quest.Visible = true
            end
            pcall(function()
                if player.Character:FindFirstChild("Title", true) and opts.hide and opts.farm then
                    player.Character.HumanoidRootPart.Title:Destroy()
                    player.Character.Head.face:Destroy()
                    for i,v in pairs(player.Character:children()) do
                        if v:isA("Accessory") or v:isA("Shirt") or v:isA("Pants") or v:isA("ShirtGraphic") then
                            v:Destroy()
                        end
                    end
                    player.Character.Stats.Speed:Destroy()
                end
            end)
        end
    end,
    Enabled = false
})

tab1.Toggle({
    Text = "Hide character",
    Callback = function(bool)
        opts.hide = bool
    end,
    Enabled = false
})

tab2.Toggle({
    Text = "Inf dash",
    Callback = function(bool)
        opts.infdash = bool
        while opts.infdash do
            setupvalue(functions.dash, 3, true)
            wait()
        end
    end,
    Enabled = false
})

tab2.Toggle({
    Text = "Disable mouse lock",
    Callback = function(bool)
        getrenv()._G.Menu = bool
        game:GetService("UserInputService").MouseBehavior = (bool and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter)
    end,
    Enabled = false
})

player.Idled:connect(function()
    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

game:GetService("Players").PlayerAdded:connect(function(plr)
    wait(math.random(2, 4))
    if plr:GetRoleInGroup(6073919) == "Tester" then
        player:Kick("Mod joined, name: "..plr.Name)
    end
end)

for i,v in pairs(getgc()) do
    if type(v) == "function" then
        if getinfo(v).name == "Combat" then
            functions.combat = v
        elseif getinfo(v).name == "Dash" and rawget(getfenv(v), "script") == player.PlayerGui.Input then
            functions.dash = v
        end
    end
end

while heartbeat:wait() do
    if opts.farm then
        pcall(function()
            for i,v in pairs(workspace.Living:children()) do
                if v.Name == opts.mob and v.Humanoid.Health > 0 then
                    while v.Humanoid.Health > 0 and player.Character.Humanoid.Health > 0 and opts.farm do
                        player.Character.HumanoidRootPart.CFrame = (v.HumanoidRootPart.CFrame * CFrame.new(0,-5,0)) * CFrame.Angles(math.rad(90),0,0)
                        coroutine.wrap(functions.combat)()
                        heartbeat:wait()
                    end
                end
            end
        end)
    end
end
