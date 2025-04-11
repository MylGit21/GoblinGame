--[[
MainMenuHandler.client.lua
This script is responsible for cloning the MainMenu GUI and setting it up for the local player.

All GUI should be parented to the the MainMenuHandler in ReplicatedFirst

Updated: 4/10/2025
Author: Makena
]]

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local LocalPlayer = game.Players.LocalPlayer


-- Cloned MainMenu GUI ---
local MainMenu = script:WaitForChild("MainMenu")
local MMclone = MainMenu:clone()

MMclone.Parent = LocalPlayer:WaitForChild("PlayerGui")
MMclone.Name = "MainMenuClone"

-- Set Values --
local MainMenuScreen = MMclone:WaitForChild("MainMenuScreen") -- Cloned 'MainMenuScreen'
local LoadingScreen = MMclone:WaitForChild("LoadingScreen") -- Cloned 'LoadingScreen'
local JoinGameScreen = MMclone:WaitForChild("JoinGameScreen") -- Cloned 'JoinGameScreen'
local OptionsScreen = MMclone:WaitForChild("OptionsScreen") -- Cloned 'OptionsScreen'
local HostGameScreen = MMclone:WaitForChild("HostGameScreen") -- Cloned 'HostGameScreen'

-- Buttons --
local JoinButton = MMclone.MainMenuScreen:WaitForChild("JoinButton") -- Join Button
local HostButton = MMclone.MainMenuScreen:WaitForChild("HostButton") -- Host Button
local OptionsButton = MMclone.MainMenuScreen:WaitForChild("OptionsButton") -- Options Button
local BackButton = MMclone:WaitForChild("BackButton") -- Back Button - UNIVERSAL

BackButton == MMclone:WaitForChild("BackButton") 

MainMenuScreen.Visible = false
LoadingScreen.Visible = true
JoinGameScreen.Visible = false
OptionsScreen.Visible = false
HostGameScreen.Visible = false



-- Preload assets --
local assets = {MainMenuScreen, LoadingScreen, JoinGameScreen, OptionsScreen, HostGameScreen, JoinButton, HostButton, OptionsButton} -- List of assets to load

local success, errorMessage = pcall(function()	
	ContentProvider:PreloadAsync(assets) -- Preload the assets
end)

if success then
	print("Assets Preloaded Successfully")
	LoadingScreen.Visible = false 							-- Hide the LoadingScreen after preloading
	MMclone.MainMenuScreen.Visible = true         
else
	print("Error Preloading Assets: " .. errorMessage)
end

-- DEBUGGING --
if (MMclone.MainMenuScreen.Visible == true) then  			-- Check if the MainMenuScreen GUI is visible - troubleshooting
	print("Clone MainMenu Loaded")
else
	print("Clone MainMenu Not Loaded")
end


-- BUTTON FUNCTIONALITY --
local function onCLickJoinButton() 
	print("Join Button Clicked") -- Debugging message
	MainMenuScreen.Visible = false
	JoinGameScreen.Visible = true
end

local function onClickHostButton() 
	print("Host Button Clicked") -- Debugging message
	MainMenuScreen.Visible = false
	HostGameScreen.Visible = true
end

local function onCLickOptionsButton()
	print("Options Button Clicked") -- Debugging message
	MainMenuScreen.Visible = false
	OptionsScreen.Visible = true
end



JoinButton.MouseButton1Click:Connect(onCLickJoinButton) -- Connect the JoinButton to the function
HostButton.MouseButton1Click:Connect(onClickHostButton) -- Connect the HostButton to the function
OptionsButton.MouseButton1Click:Connect(onCLickOptionsButton) -- Connect the OptionsButton to the function
