local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players") 
local LocalPlayer = Players.LocalPlayer -- Local Player

local MainMenu = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainMenuClone")
local HostGameScreen = MainMenu:WaitForChild("HostGameScreen") -- HostGame Screen
local hostGameButton = HostGameScreen.Container:WaitForChild("HostButton") -- Host Game Button
local InLobbyScreen = MainMenu:WaitForChild("InLobbyScreen")

local function onClickHostButton()
    print("Host Game Button Clicked")
    -- Hide the main menu and show the host game screen
    HostGameScreen.Visible = false
    InLobbyScreen.Visible = true
end


hostGameButton.MouseButton1Click:Connect(onClickHostButton) -- Connect the button click to the function
