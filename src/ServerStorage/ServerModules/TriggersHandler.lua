local TriggersHandler = {}
local TriggersFolder = workspace:WaitForChild("World"):WaitForChild("Traps&Triggers")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GateDebounce, GateOpen = false, false
local Tasks = {}
local Debounces = {}

function DungeonFunction(DungeonKey)
	TweenService:Create(DungeonKey, TweenInfo.new(DungeonKey.Speed.Value), {Position = DungeonKey.LastPosition.Value}):Play()
	DungeonKey.LastPosition.Value = DungeonKey.Position
	if DungeonKey:FindFirstChild("LastRotation") then
		TweenService:Create(DungeonKey, TweenInfo.new(DungeonKey.Speed.Value), {Orientation = DungeonKey.LastRotation.Value}):Play()
		DungeonKey.LastRotation.Value = DungeonKey.Orientation
	end
	for _, v in pairs(DungeonKey:GetChildren()) do
		if v:IsA("Sound") then
			v:Play()
			break
		end
	end
end

for _, v in pairs(TriggersFolder:GetChildren()) do
	local ClickDetectors = v:FindFirstChild("ClickDetector", true)
	if ClickDetectors and v:FindFirstChild("Target", true) then
		Debounces[v:FindFirstChild("Target", true).Value] = false
		ClickDetectors.MouseClick:Connect(function(Player)
			local Target = v:FindFirstChild("Target", true)
			if not Target then return end
			if not Debounces[Target.Value] then
				if v.Name == "lever01" then --means they want to keep it open
					if Tasks[Target.Value] then task.cancel(Tasks[Target.Value]) Tasks[Target.Value] = nil end
					Debounces[Target.Value] = true
					Tasks[Target.Value] = task.spawn(function()
						task.spawn(function() DungeonFunction(Target.Value) end)
						task.spawn(function() DungeonFunction(v.mainPart) end)
						task.wait(Target.Value.Speed.Value)
						Debounces[Target.Value] = false
					end)
				elseif v.Name == "button01" and Target.Value.Position ~= Target.Value.InitialPosition.Value then
					if Tasks[Target.Value] then task.cancel(Tasks[Target.Value]) Tasks[Target.Value] = nil end
					Debounces[Target.Value] = true
					Tasks[Target.Value] = task.spawn(function()
						task.spawn(function() DungeonFunction(Target.Value) end)
						task.spawn(function() DungeonFunction(v.mainPart) end)
						task.wait(Target.Value.Speed.Value + Target.Value.OpenTime.Value)
						task.spawn(function() DungeonFunction(Target.Value) end)
						task.spawn(function() DungeonFunction(v.mainPart) end)
						task.wait(Target.Value.Speed.Value + Target.Value.OpenTime.Value)
						Debounces[Target.Value] = false
					end)
				end
			end
		end)
	elseif v.Name == "KillPart" then
		v.Touched:Connect(function(Part)
			if not Debounces[v] and Part.Parent:FindFirstChild("Humanoid") then
				task.spawn(function()
					Debounces[v] = true
					Part.Parent.Humanoid.Health = 0
					task.wait(.5)
					Debounces[v] = false
				end)
			end
		end)
	elseif v.Name == "TrapToggle" then
		v.Touched:Connect(function(Part)
			if not Debounces[v] and Part.Parent:FindFirstChild("Humanoid") then
				task.spawn(function()
					Debounces[v] = true
					if v.Target.Value:FindFirstChild("Delay1", true) and v.Target.Value:FindFirstChild("Delay2", true) then
						v.Sound:Play()
						task.wait(math.random(v.Target.Value.Delay1.Value,v.Target.Value.Delay2.Value))
						v.Target.Value.Enabled = false
						task.wait(v.Target.Value.OpenTime.Value)
						v.Target.Value.Enabled = true
					end
					Debounces[v] = false
				end)
			end
		end)
	end
end

return TriggersHandler
