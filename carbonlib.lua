local module = {}

-- Create Library Functions

-- Main func, must be executed before using functions like safe_highlight

function module.loadLib()
    local fs = Instance.new("Folder")
    fs.Name = "CarbonLibrary"
    fs.Parent = game:WaitForChild("CoreGui")
    local hs = Instance.new("Folder")
    hs.Name = "Highlights"
    hs.Parent = fs
end

function module.secure_call(call, delay)
	ypcall(function()
		xpcall(nil, function()
		     pcall(function()
			task.spawn(function()
			    for index = 1, 1 do
				task.delay(delay, function()
				    if game.Players.LocalPlayer.Character then
					ypcall(function()
					    task.spawn(function()
						if game:IsLoaded() then
						    task.defer(call)    
						end
					    end)    
					end)
				    end
				end)
			    end
			end)
		 end)
	    end)
	end)	
end

function module.spoof_value(name, value)
    local mt = getrawmetatable(game)
    make_writeable(mt);
    local old_index = mt.__index
    
    mt.__index = function(i, vls)
        if tostring(i) == name then
            if tostring(vls) == "Value" then
                return value  
            end
        end
        
        return old_index(i,vls)
    end	
end

function module.disable_function(func)
    hookfunction(func, function(...)
        return nil    
    end)	
end

function module.IsLoaded()
   local exists = false
   if game:WaitForChild("CoreGui"):FindFirstChild("CarbonLibrary") then
		exists = true
	else
		exists = false
	end
	
	return exists
end

function module.get_nearest(x)
    local dist = math.huge -- inf
    local target = nil --- Nil, no target yet.
    local localplayer = game.Players.LocalPlayer
	for i,v in pairs(game:GetService("Players"):GetPlayers()) do
		if v ~= localplayer then
			if v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then --- Alive checks
                if x then
                    if v.TeamColor ~= localplayer.TeamColor then
                        local magnitude = (v.Character.Head.Position - localplayer.Character.Head.Position).magnitude
                        if magnitude < dist then
                            dist = magnitude
                            target = v
                        end
                    end
                else
                    local magnitude = (v.Character.Head.Position - localplayer.Character.Head.Position).magnitude
                    if magnitude < dist then
                        dist = magnitude
                        target = v
                    end
                end
			end
		end
    end

    return target
end

function module.set_callback(x)
    spawn(x)
end


function module.getPlr()
    return game.Players.LocalPlayer

end

function module.get_cframe(part, path, isplr)
    local cframe = nil

    if isplr then
        if game.Players.LocalPlayer.Character:FindFirstChild(part) then
             cframe = game.Players.LocalPlayer.Character[part].CFrame
            
        end
    else
        if path:FindFirstChild(part) then
            cframe = path[part].CFrame
        end
    end

    return cframe
end

function module.set_camera(x)
    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, x)
end

function module.import_object(x, parent)
    game:GetObjects(x)[1].Parent = parent
end

function module.move_to(x)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x
end

function module.random_plr()
    local num = math.random(1, #game.Players:GetChildren())
    return game.Players:GetChildren()[num]
end

function module.get_health(plr)
    return game.Players[plr].Character.Humanoid.Health
end

function module.set_gravity(x)
    workspace.Gravity = x
end

function module.bind_function(x, callback)
    local plrm = game.Players.LocalPlayer:GetMouse()

    plrm.KeyDown:Connect(function(key)
        if key == x then
            spawn(callback)
        end
    end)
end

function module.get_mouse()
    return game.Players.LocalPlayer:GetMouse()
end

function module.safe_highlight(part, name, r, g, b)
    local h = Instance.new("Highlight")
    h.Name = name
    h.DepthMode = "AlwaysOnTop"
    h.FillColor = Color3.fromRGB(r,g,b)
    h.Adornee = part
    h.Parent = game:WaitForChild("CoreGui")["CarbonLibrary"]["Highlights"]
end

function module.unhighlight(x)
    game:WaitForChild("CoreGui")["CarbonLibrary"]["Highlights"][x].Parent = nil

end


function module.protect_gui(x)
    if game.Players.LocalPlayer.PlayerGui[x]:IsA("ScreenGui") then
        game.Players.LocalPlayer.PlayerGui[x].Parent = game.CoreGui["CarbonLibrary"]
    else
        print("[CarbonLib] protect_gui("..x..") failed: Not a gui [CarbonLib: NaG]" )
    end
end

return module
