-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Settings
local DebugMode = true

-- Storage Variables
local DungeonAssets = ReplicatedStorage:WaitForChild("DungeonAssets")
local StartingRooms = DungeonAssets:WaitForChild("StartingRooms")
local WallVariations = DungeonAssets:WaitForChild("WallVariations")
local CheckPart = DungeonAssets.CheckPart
local DungeonFolder = workspace.Dungeon
local DebrisFolder = workspace.Debris

-- Main Generation Function
local function GenerateDungeon(startingPosition, maxNodes)
	local nodesGenerated = 0
	local generatedNodes = {}

	local function CreateNode(model, parent)
		print("Creating", model.Name, "in", parent)
		local waypoints = {}
		for _, part in pairs(model:GetChildren()) do
			if part:IsA("BasePart") and part.Name == "Waypoint" then
				table.insert(waypoints, part)
			end
		end
		return {model = model, waypoints = waypoints, parent = parent}
	end

	local function PositionNode(node, waypoint)
		local primary = node.model.PrimaryPart

		-- Get the opposite facing direction and the offset
		local rotatedCFrame = waypoint.CFrame * CFrame.Angles(0, math.rad(180), 0)
		local offset = rotatedCFrame.LookVector * -9.04

		-- Set the new position and orientation
		node.model:SetPrimaryPartCFrame(rotatedCFrame + offset)
	end


	local function CanPlace(node, waypoint)
		local checkPart = CheckPart:Clone()
		checkPart.Parent = DebrisFolder
		checkPart.Size = node.model:GetModelSize()

		-- Apply the same rotation as in PositionNode
		local rotatedCFrame = waypoint.CFrame * CFrame.Angles(0, 0, 0)
		local offsetDistance = 2
		local offset = rotatedCFrame.LookVector * (offsetDistance + checkPart.Size.Z / 2)

		-- Set the position and orientation of the checkPart
		checkPart.CFrame = rotatedCFrame + offset
		task.wait()
		local parts = workspace:GetPartsInPart(checkPart)

		if #parts > 0 then
			print("Expansion Blocked By", #parts, "Parts")
			if not DebugMode then checkPart:Destroy() end
			return false
		else
			checkPart:Destroy()
			return true
		end
	end

	local function CleanNode(node, waypoint)
		for _, child in pairs(node:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "PrimaryPart" then
				child:Destroy()
			end
			if waypoint and child.Name == "Waypoint" then
				child:Destroy()
			end
		end
	end

	local function BlockWay(node, waypoint)
		local Wall = WallVariations:GetChildren()[math.random(1, #WallVariations:GetChildren())]:Clone()
		Wall:SetPrimaryPartCFrame(waypoint.CFrame)
		Wall.Parent = node.model
		waypoint:Destroy()
	end

	local function GetRandomCorridor(node)
		-- Helper Function to convert the string into a table
		local function stringToTable(input)
			if input then
				local result = {}
				-- Use gmatch to find all quoted values
				for value in input:gmatch('"([^"]+)"') do
					table.insert(result, value)
				end
				return result
			else
				return nil
			end
		end

		local weightedList = {}
		local nextNodeTypes = stringToTable(node.model:GetAttribute("NextNodeTypes")) or {"Hallway"} -- Default to Hallway if not set

		-- Loop through all corridors and add them to the weighted list based on rarity and nextNodeTypes
		for _, corridor in pairs(DungeonAssets.CorridorFolder:GetChildren()) do
			local corridorType = corridor:GetAttribute("NodeType")
			if table.find(nextNodeTypes, corridorType) then
				local rarity = corridor:GetAttribute("Rarity") or 1 -- Defaults to 1 if not set
				for i = 1, rarity do
					table.insert(weightedList, corridor)
				end
			end
		end

		-- Select a random hallway from the weighted list
		if #weightedList > 0 then
			return weightedList[math.random(#weightedList)]
		else
			warn("No valid corridors found for NextNodeTypes: ", nextNodeTypes)
			return nil -- Handle the case where no valid corridors are found
		end
	end


	local function Expand(node)
		--print("Expanding from", node.model.Name)
		for _, waypoint in pairs(node.waypoints) do
			if nodesGenerated >= maxNodes then 
				BlockWay(node,waypoint)
			else
				task.spawn(function()
					wait(1)
					local corridor = GetRandomCorridor(node)
					local newNode = CreateNode(corridor:Clone(), DungeonFolder)
					if CanPlace(newNode, waypoint) then
						PositionNode(newNode, waypoint)
						newNode.model.Parent = newNode.parent
						if not DebugMode then CleanNode(newNode.model, true) end
						table.insert(generatedNodes, newNode)
						nodesGenerated += 1
						Expand(newNode)
					else
						BlockWay(node,waypoint)
					end
				end)
			end
		end
	end

	-- Create Starting Room
	local startRoom = StartingRooms:FindFirstChild("PrisonStart")
	local startNode = CreateNode(startRoom:Clone(), DungeonFolder)
	startNode.model:SetPrimaryPartCFrame(CFrame.new(startingPosition))
	startNode.model.Parent = startNode.parent
	CleanNode(startNode.model, true)
	Expand(startNode)
end

GenerateDungeon(Vector3.new(14.569, 16.195, -490.368), 50)
