-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local DungeonModule = require(ReplicatedStorage.DungeonAssets.CorridorDictionary)

-- Settings
local DebugMode = true

-- Storage Variables
local DungeonAssets = ReplicatedStorage:WaitForChild("DungeonAssets")
local CorridorFolder = DungeonAssets:WaitForChild("CorridorFolder")
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
		--print("Creating", model.Name, "in", parent)
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
		-- Find the node data in the dictionary
		local nodeData
		for category, subcategories in pairs(DungeonModule.dict) do
			for subcategory, items in pairs(subcategories) do
				for _, item in ipairs(items) do
					if item.ModelName == node.model.Name then
						nodeData = item
						break
					end
				end
				if nodeData then break end
			end
			if nodeData then break end
		end

		local nextNodeTypes = nodeData and nodeData.NextNodeTypes or {"Hallway"}
		local weightedList = {}

		-- Loop through all corridors in the dictionary
		for category, subcategories in pairs(DungeonModule.dict) do
			-- Check if this category matches any of our NextNodeTypes
			for _, allowedType in ipairs(nextNodeTypes) do
				if category == allowedType then
					for subcategory, items in pairs(subcategories) do
						for _, item in ipairs(items) do
							local rarity = item.Rarity or 1
							local model = CorridorFolder:FindFirstChild(item.ModelName)
							if model then
								for i = 1, rarity do
									table.insert(weightedList, model)
								end
							end
						end
					end
					break  -- Found matching category, move to next
				end
			end
		end

		-- Select a random hallway from the weighted list
		if #weightedList > 0 then
			return weightedList[math.random(#weightedList)]
		else
			warn("No valid corridors found for NextNodeTypes: ", table.concat(nextNodeTypes, ", "))
			return nil
		end
	end

	local function Expand(node)
		for _, waypoint in pairs(node.waypoints) do
			if nodesGenerated >= maxNodes then 
				BlockWay(node,waypoint)
			else
				task.spawn(function()
					wait(1)
					local corridor = GetRandomCorridor(node)
					if corridor then
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