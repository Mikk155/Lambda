if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.PlayersLocked = false

MAPSCRIPT.DefaultLoadout = {
    Weapons = {"weapon_lambda_medkit", "weapon_crowbar", "weapon_pistol", "weapon_smg1", "weapon_357", "weapon_physcannon", "weapon_frag", "weapon_shotgun", "weapon_ar2", "weapon_rpg"},
    Ammo = {
        ["Pistol"] = 118,
        ["SMG1"] = 90,
        ["357"] = 12,
        ["Grenade"] = 3,
        ["Buckshot"] = 12,
        ["AR2"] = 60,
        ["RPG_Round"] = 3,
        ["SMG1_Grenade"] = 1
    },
    Armor = 60,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}

MAPSCRIPT.EntityFilterByName = {
    ["player_spawn_items"] = true
}

MAPSCRIPT.VehicleGuns = true

function MAPSCRIPT:PostInit()
    if SERVER then
        -- 3233.962402 -5601.413086 1564.521851
        local checkpoint0 = GAMEMODE:CreateCheckpoint(Vector(3332.003174, 1683.768311, 1536.031250), Angle(0, -90, 0))
        GAMEMODE:SetPlayerCheckpoint(checkpoint0)
        local checkpoint4 = GAMEMODE:CreateCheckpoint(Vector(3325.756836, -5639.022461, 1536.031250), Angle(0, 0, 0))
        local checkpointTrigger4 = ents.Create("trigger_multiple")
        checkpointTrigger4:SetupTrigger(Vector(3302.523193, -5592.021484, 1536.031250), Angle(0, 0, 0), Vector(-250, -105, 0), Vector(250, 105, 200))

        checkpointTrigger4.OnTrigger = function(trigger, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint4, activator)
            trigger:Disable()
        end

        GAMEMODE:WaitForInput("button_trigger", "Use", function()
            checkpoint4:Reset()
            checkpointTrigger4:Enable()
            GAMEMODE:EnablePreviousMap()
        end)
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

return MAPSCRIPT