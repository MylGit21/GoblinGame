--/ChangeAbles/--

local daystart = 6.5 --when day starts
local nightstart = 17.5 --when night starts
local dayminutes = 30 --minutes for day 30
local nightminutes = 45 --minutes for night 45
local updateticks = 40 --How many Frames before Updating the Zone
local BaseLighting = script.Parent.DefaultLighting --The Default Lighting
local lcs = .02 --Lighting Transition Percentage for Lerp
local clockcs = .1
local updatetime = 240 --Time before the Client Gets current time from Server (anti desync)

--/Script/--

local module = {}
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local BaseZones = script.Parent.BaseZones
local Remotes = script.Parent.Remotes
local RFunc = Remotes.LightingFunction

local plr = RS:IsServer() or Players.LocalPlayer

module.Zones = {}
module.CurrentGoalLight = nil
module.TimeOfDay = 0

local daymult = 1/(dayminutes*60/(nightstart-daystart))
local nightmult = 1/(nightminutes*60/(24-(nightstart-daystart)))

local function GetTab(base,zn)
	for _,a in pairs(base) do
		if a:IsA("Folder") then
			if a.Name == "Day" or a.Name == "Night" then continue end
			zn[a.Name] = {}
			for _,b in pairs(a:GetChildren()) do
				zn[a.Name][b.Name] = b.Value
			end
		else
			zn[a.Name] = a.Value
		end
	end
	return zn
end

local function GetNameFromTab(tab,wanted)
	for i,v in pairs(tab) do
		if v.Name == wanted then
			return tab[i]
		end
	end
end

local function GetDN(base,zn)
	local day,night = GetNameFromTab(base,"Day"),GetNameFromTab(base,"Night")
	zn.Day = GetTab(day and day:GetChildren() or base,zn.Day)
	zn.Night = GetTab(night and night:GetChildren() or base,zn.Night)
	return zn
end

local function SetUpZones()
	for i,v in pairs(workspace.EnvironmentTriggers:GetChildren()) do
		if not v:IsA("BasePart") then continue end
		local zn = {Day = {},Night = {},CheckArea = {v.CFrame,v.Size,v.Name}}
		zn = GetDN(BaseZones:FindFirstChild(v.Name) and BaseZones[v.Name]:GetChildren() or {},zn)
		zn = GetDN(v:GetChildren() or {},zn)
		v:Destroy()
		table.insert(module.Zones,zn)
	end
	workspace.EnvironmentTriggers:Destroy()
end

local function GetRoot()
	return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

function module.GetCurrentZone()
	local root = GetRoot()
	if not root then return end
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = {root.Parent}
	for i,v in pairs(module.Zones) do
		local results = workspace:GetPartBoundsInBox(v.CheckArea[1],v.CheckArea[2],params)
		if not results or #results <1 then continue end
		return v
	end
end

local function Lerp(a,b,t)
	local ret
	if typeof(a) == "Color3" then
		ret = a:Lerp(b,t)
	elseif typeof(a) == "boolean" then
		ret = b
	elseif typeof(a) == "number" then
		ret = a+(b-a)*t
	end
	return ret
end

local function GetTimeName()
	return (module.TimeOfDay >= daystart and module.TimeOfDay <= nightstart) and "Day" or "Night"
end

local function ClockTimeTweening(current,goal,t)
	t = t or clockcs
	local dist = math.abs(current-goal)
	if dist >= 12 then
		local b = Lerp(current,current+(current >= 12 and (-dist+24) or -(-dist+24)),t)
		if b > 24 then
			b+=-24
		elseif b < 0 then
			b+=24
		end
		return b
	else
		return Lerp(current,goal,t)
	end
end

local function TweenLighting(tab,inst,b)
	if not inst then return end
	for i,v in pairs(tab) do
		if type(v) == "table" then TweenLighting(tab[i],inst:FindFirstChild(i)) continue end
		if b and i == "ClockTime" then
			inst[i] = ClockTimeTweening(inst[i],v)
		else
			inst[i] = Lerp(inst[i],v,lcs)
		end
	end
	return b and tab.ClockTime
end

local function TimeLoop()
	local counter = 0
	RS.Heartbeat:Connect(function(dt)
		dt *= GetTimeName() == "Day" and daymult or nightmult
		module.TimeOfDay += dt -(module.TimeOfDay+dt>=24 and 24 or 0)
		if RS:IsClient() then
			local tick1 = os.clock()
			if not TweenLighting((module.CurrentGoalLight or BaseLighting)[GetTimeName()],Lighting,true) then
				local t = Lighting.ClockTime
				Lighting.ClockTime = math.abs(t-module.TimeOfDay)<=.1 and module.TimeOfDay or ClockTimeTweening(t,module.TimeOfDay,math.min(1,clockcs*2))
			end
			counter+=1
			if counter >= updateticks then
				counter = 0
				module.CurrentGoalLight = module.GetCurrentZone()
			end
			--print(os.clock()-tick1)
		end
	end)
end

local function ClientRequest(plr,arg)
	if arg == "GetTime" then
		return module.TimeOfDay
	elseif arg == "GetZones" then
		return module.Zones
	end
end

local function ClientUpdate()
	while task.wait(updatetime) do
		module.TimeOfDay = RFunc:InvokeServer("GetTime")
	end
end

if RS:IsServer() then
	module.TimeOfDay = Lighting.ClockTime
	SetUpZones()
	--warn("Lighting System finished and loaded "..#module.Zones.." PartAreas!")
	RFunc.OnServerInvoke = ClientRequest
else
	BaseLighting = GetDN(BaseLighting:GetChildren(),{Day={},Night={}})
	module.TimeOfDay = RFunc:InvokeServer("GetTime")
	module.Zones = RFunc:InvokeServer("GetZones")
	task.spawn(ClientUpdate)
end
TimeLoop()

return module