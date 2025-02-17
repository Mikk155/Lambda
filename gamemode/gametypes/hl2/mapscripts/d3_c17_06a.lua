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
    ["pclip_gate1"] = true,
    ["player_spawn_template"] = true
}

function MAPSCRIPT:PostInit()
    if SERVER then
        -- 1921.614014 -5632.266602 320.031250
        local checkpoint1 = GAMEMODE:CreateCheckpoint(Vector(3187.333984, 2184.848145, -312.009857), Angle(0, 180, 0))
        checkpoint1:SetVisiblePos(Vector(3034.239258, 2188.360840, -318.995728))
        local checkpointTrigger1 = ents.Create("trigger_once")
        checkpointTrigger1:SetupTrigger(Vector(3187.333984, 2184.848145, -312.009857), Angle(0, 0, 0), Vector(-250, -110, 0), Vector(110, 110, 100))

        checkpointTrigger1.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint1, activator)
        end

        -- 2937.786865 2507.701416 -319.968750 6.483 89.871 0.000
        local checkpoint2 = GAMEMODE:CreateCheckpoint(Vector(2667.206787, 3911.651367, -323.968750), Angle(0, 90, 0))
        local checkpointTrigger2 = ents.Create("trigger_once")
        checkpointTrigger2:SetupTrigger(Vector(2945.403076, 2563.369629, -319.968750), Angle(0, 0, 0), Vector(-30, -30, 0), Vector(30, 30, 100))

        checkpointTrigger2.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint2, activator)
        end
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

return MAPSCRIPT