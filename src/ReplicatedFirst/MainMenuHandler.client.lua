--[[
MainMenuHandler.client.lua
This script is responsible for cloning the MainMenu GUI and setting it up for the local player.


Updated: 4/10/2025
Author: Makena
]]

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = game.Players.LocalPlayer


-- Cloned MainMenu GUI ---
local MainMenu = script:WaitForChild("MainMenu")
local MMclone = MainMenu:clone()

MMclone.Parent = LocalPlayer:WaitForChild("PlayerGui")
MMclone.Name = "MainMenuClone"


----- Load GUI -----
MMclone.MainMenuScreen.Visible = true;            -- Show the cloned MainMenuScreen

if (MMclone.MainMenuScreen.Visible == true) then  -- Check if the GUI is visible - troubleshooting
	print("Clone MainMenu Loaded")
else
	print("Clone MainMenu Not Loaded")
end



