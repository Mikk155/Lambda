if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.PlayersLocked = false

MAPSCRIPT.DefaultLoadout = {
    Weapons = {"weapon_lambda_medkit", "weapon_crowbar", "weapon_pistol", "weapon_smg1", "weapon_357", "weapon_physcannon", "weapon_frag", "weapon_shotgun", "weapon_ar2", "weapon_rpg", "weapon_crossbow", "weapon_bugbait"},
    Ammo = {
        ["Pistol"] = 218,
        ["SMG1"] = 90,
        ["357"] = 12,
        ["Grenade"] = 3,
        ["Buckshot"] = 12,
        ["AR2"] = 60,
        ["RPG_Round"] = 3,
        ["SMG1_Grenade"] = 1,
        ["XBowBolt"] = 5
    },
    Armor = 60,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}

MAPSCRIPT.EntityFilterByName = {
    ["player_spawn_items"] = true,
    ["pclip_gate1"] = true
}

function MAPSCRIPT:PostInit()
    if SERVER then
        -- 1200.359985 3379.639893 768.816528
        -- Make sure the player spawns at the correct spot.
        local spawn = ents.Create("info_player_start")
        spawn:SetPos(Vector(1200.359985, 3379.639893, 768.816528))
        spawn:SetAngles(Angle(0, -130, 0))
        spawn:SetKeyValue("spawnflags", "1")
        spawn:Spawn()
        --  645.813293 3391.362061 192.031250
        local checkpoint1 = GAMEMODE:CreateCheckpoint(Vector(645.813293, 3391.362061, 192.031250), Angle(0, -180, 0))
        local checkpointTrigger1 = ents.Create("trigger_once")
        checkpointTrigger1:SetupTrigger(Vector(645.813293, 3391.362061, 192.031250), Angle(0, 0, 0), Vector(-50, -50, 0), Vector(50, 50, 100))

        checkpointTrigger1.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint1, activator)
        end

        local checkpoint2 = GAMEMODE:CreateCheckpoint(Vector(-2476.636963, 6708.353516, 128.031250), Angle(0, 90, 0))
        checkpoint2:SetVisiblePos(Vector(-2494.347412, 6463.139648, 128.031250))
        local checkpointTrigger2 = ents.Create("trigger_once")
        checkpointTrigger2:SetupTrigger(Vector(-2494.347412, 6463.139648, 128.031250), Angle(0, 0, 0), Vector(-50, -50, 0), Vector(50, 50, 100))

        checkpointTrigger2.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint2, activator)
        end
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

return MAPSCRIPT