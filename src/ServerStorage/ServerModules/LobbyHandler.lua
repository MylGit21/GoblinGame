--[[
HostGameHandler.client.lua
This module script is responsible for handling the hosting of games, including creating and deleting lobbies.

Updated: 4/17/2025
Author: Makena
]]


local LobbyHandler = {}

local lobbies = {}
local playerLobbies = {}


function randomId() -- For creating a random lobby ID 6 integers
	local id = task.wait(2)
	id = math.random(100000, 999999)
	return id
end

function LobbyHandler:CreateLobby(player, lobbyId)
    if lobbies[lobbyId] then
        error("Lobby ID already exists: " .. lobbyId)
    end
    lobbies[lobbyId] = {
        Owner = player,
        Members = {player}
        lobbyId = lobbyId,
        isActive = true,
    }

    return true, "Creating lobby for player:", player.Name, "with ID:", lobbyId
end

function LobbyHandler:DeleteLobby(player,lobbyId)
    if not lobbies[lobbyId] then
        error("Lobby ID does not exist: " .. lobbyId)
    end

    if not table.find(lobbies[lobbyId].players, player) then
        error("Player is not in the lobby: " .. player.Name)
    end
