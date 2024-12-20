if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.PlayersLocked = false

MAPSCRIPT.DefaultLoadout = {
    Weapons = {"weapon_lambda_medkit", "weapon_crowbar", "weapon_pistol", "weapon_smg1", "weapon_357", "weapon_physcannon", "weapon_frag", "weapon_shotgun"},
    Ammo = {
        ["Pistol"] = 118,
        ["SMG1"] = 90,
        ["357"] = 12,
        ["Grenade"] = 3,
        ["Buckshot"] = 12
    },
    Armor = 60,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}

MAPSCRIPT.EntityFilterByName = {
    ["player_spawn_template"] = true
}

function MAPSCRIPT:PostInit()
    if SERVER then
        -- 1915.561768 -19.246124 -5120.762695
        local checkpoint1 = GAMEMODE:CreateCheckpoint(Vector(1893.508423, 365.617035, -5120.287109), Angle(0, -90, 0))
        local checkpointTrigger1 = ents.Create("trigger_once")
        checkpointTrigger1:SetupTrigger(Vector(1915.561768, -19.246124, -5120.762695), Angle(0, 0, 0), Vector(-150, -50, 0), Vector(150, 50, 70))

        checkpointTrigger1.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint1, activator)
        end
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

return MAPSCRIPT