if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.DefaultLoadout = {
    Weapons = {"weapon_crowbar", "weapon_physcannon", "weapon_pistol", "weapon_smg1", "weapon_357", "weapon_shotgun", "weapon_frag", "weapon_ar2", "weapon_crossbow", "weapon_rpg"},
    Ammo = {
        ["Pistol"] = 18,
        ["SMG1"] = 45,
        ["357"] = 6,
        ["Buckshot"] = 12,
        ["Grenade"] = 3,
        ["AR2"] = 50,
        ["SMG1_Grenade"] = 1,
        ["XBowBolt"] = 4
    },
    Armor = 0,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}
MAPSCRIPT.EntityFilterByName = {
    ["global_newgame_spawner_dynamic"] = true,
    ["global_newgame_spawner_suit"] = true,
    ["global_newgame_spawner_pistol"] = true,
    ["global_newgame_spawner_crowbar"] = true,
    ["global_newgame_spawner_physgun"] = true,
    ["global_newgame_spawner_shotgun"] = true,
    ["global_newgame_spawner_smg"] = true,
    ["global_newgame_spawner_ar2"] = true,
    ["global_newgame_spawner_rpg"] = true,
    ["global_newgame_spawner_xbow"] = true,
}

MAPSCRIPT.GlobalStates = {
    ["super_phys_gun"] = GLOBAL_OFF
}

MAPSCRIPT.Checkpoints = {}
function MAPSCRIPT:PostInit()
    -- Force the NPCs to follow the player. Squads in Garry's Mod are a bit broken, the replacement
    -- lambda_player_follow entity is a bit more reliable but also quite hacky.
    local playerFollow = ents.Create("lambda_player_follow")
    playerFollow:SetName("lambda_follow_player")
    playerFollow:SetKeyValue("actor", "citizen_refugees*")
    playerFollow:Spawn()
    playerFollow:Activate()
    -- Alyx should wait for everyone at the end before closing
    ents.WaitForEntityByName(
        "counter_everyone_in_place_for_barney_goodbye",
        function(ent)
            ent:SetKeyValue("max", "6")
        end
    )

    -- Make the doors at the end close when we are ready
    local trainCheckpoint = ents.Create("trigger_once")
    trainCheckpoint:SetupTrigger(Vector(9876, 9628, -680), Angle(0, 0, 0), Vector(-190, -220, -60), Vector(236, 220, 60))
    trainCheckpoint:SetKeyValue("teamwait", "1")
    trainCheckpoint:SetKeyValue("showwait", "1")
    trainCheckpoint:SetKeyValue("StartDisabled", "1")
    trainCheckpoint:SetName("lambda_close_doors")
    trainCheckpoint:AddOutput("OnTrigger", "counter_everyone_in_place_for_barney_goodbye", "Add", "1", 0.0, "1")
    -- When barney arrives add to the counter so alyx will start closing the door.
    ents.WaitForEntityByName(
        "rallypoint_barney_lasttrain",
        function(ent)
            ent:Fire("AddOutput", "OnArrival lambda_close_doors,Enable,,0,-1", "0.0")
        end
    )

    -- Disallow shoving the NPC near the door out of the way.
    ents.WaitForEntityByName(
        "citizen_blocker",
        function(ent)
            ent:SetKeyValue("spawnflags", "1458180")
        end
    )

    -- Place another train infront of the existing one.
    local propTrain = ents.Create("prop_dynamic")
    propTrain:SetModel("models/props_trainstation/train_outro_car01.mdl")
    propTrain:SetPos(Vector(9405.219727, 9196.559570, -727.476013))
    propTrain:SetAngles(Angle(0, -90, 0))
    propTrain:Spawn()
end

function MAPSCRIPT:PostPlayerSpawn(ply)
end

return MAPSCRIPT