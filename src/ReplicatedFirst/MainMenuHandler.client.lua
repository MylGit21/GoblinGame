--[[
MainMenuHandler.client.lua
This script is responsible for cloning the MainMenu GUI and setting it up for the local player.

All GUI should be parented to the the MainMenuHandler in ReplicatedFirst

Updated: 4/17/2025
Author: Makena
]]

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local LocalPlayer = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

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

BackButton = MMclone:WaitForChild("BackButton") 

-- Tweening Variables  - Setting Button Positions in prep for animation --

-- Button Positions --
JoinButton.Position = UDim2.new(-1.095, 0, 0.216, 0) -- Join Button Position
HostButton.Position = UDim2.new(-1.095, 0, 0.389, 0) -- Host Button Position
OptionsButton.Position = UDim2.new(-1.095, 0, 0.698, 0) -- Options Button Position


MainMenuScreen.Visible = false
LoadingScreen.Visible = true
JoinGameScreen.Visible = false
OptionsScreen.Visible = false
HostGameScreen.Visible = false

-- CAMERA CFRAME ------			- Would like to have animation for the menu instead of just a static camera
local camera = game.Workspace.CurrentCamera
local cameraPart = game.Workspace:WaitForChild("IntroCam")

camera.CameraType = Enum.CameraType.Scriptable
camera.CFrame = cameraPart.CFrame -- Set the camera to the IntroCam part

------------------------------- Preload assets -------------------------
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

------------------------------ Tweening -----------------------------
wait(2)   -- Can change for when to start the tweening

local JoinButtonTweenPosition = TweenService:Create(JoinButton, TweenInfo.new(2), {Position = UDim2.new(0.095, 0, 0.216, 0)}) -- Tween for Join Button
JoinButtonTweenPosition:Play() -- Play the tween

local HostButtonTweeenPosition = TweenService:Create(HostButton, TweenInfo.new(3), {Position = UDim2.new(0.095, 0, 0.389, 0)}) -- Tween for Host Button
HostButtonTweeenPosition:Play() -- Play the tween

local OptionsButtonTweenPosition = TweenService:Create(OptionsButton, TweenInfo.new(4), {Position = UDim2.new(0.095, 0, 0.698, 0)}) -- Tween for Options Button
OptionsButtonTweenPosition:Play() -- Play the tween


--------------------------- BUTTON FUNCTIONALITY ---------------------

local function onCLickJoinButton() 
	print("Join Button Clicked") -- Debugging message
	MainMenuScreen.Visible = false
	JoinGameScreen.Visible = true

	-- BindableEvent to Signal local script handlers
end


local function onClickHostButton() 
	print("Host Button Clicked") -- Debugging message
	MainMenuScreen.Visible = false
	HostGameScreen.Visible = true

	-- BindableEvent to Signal local script handlers
end

local function onCLickOptionsButton()
	print("Options Button Clicked") -- Debugging message
	MainMenuScreen.Visible = false
	OptionsScreen.Visible = true
	BackButton.Visible = true 
end

-- Back Button ------ If there is a simplier way to do this, feel free to edit!
local function onClickOptionsBackButton() 
	print("Back Button Clicked") -- Debugging message
	MainMenuScreen.Visible = true
	JoinGameScreen.Visible = false
	OptionsScreen.Visible = false
	HostGameScreen.Visible = false
	BackButton.Visible = false 
end

local function onClickHostBackButton()
	print("Back Button Clicked") -- Debugging message
	MainMenuScreen.Visible = true
	JoinGameScreen.Visible = false
	OptionsScreen.Visible = false
	HostGameScreen.Visible = false
	BackButton.Visible = false 
end

local function onCLickJoinBackButton()
	print("Back Button Clicked") -- Debugging message
	MainMenuScreen.Visible = true
	JoinGameScreen.Visible = false
	OptionsScreen.Visible = false
	HostGameScreen.Visible = false
	BackButton.Visible = false 
end
----------------------------------

JoinButton.MouseButton1Click:Connect(onCLickJoinButton)
HostButton.MouseButton1Click:Connect(onClickHostButton)
OptionsButton.MouseButton1Click:Connect(onCLickOptionsButton) 


OptionsScreen.BackButton.MouseButton1Click:Connect(onClickOptionsBackButton)
HostGameScreen.BackButton.MouseButton1Click:Connect(onClickHostBackButton)
JoinGameScreen.BackButton.MouseButton1Click:Connect(onCLickJoinBackButton)