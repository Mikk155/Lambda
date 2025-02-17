if SERVER then
    AddCSLuaFile()
end

local DbgPrint = GetLogging("MapScript")
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

MAPSCRIPT.InputFilters = {
    ["door_controlroom_1"] = {"Close", "Lock"},
    ["door_room1_gate"] = {"Close"}
}

MAPSCRIPT.EntityFilterByClass = {}

MAPSCRIPT.EntityFilterByName = {
    ["global_newgame_template_base_items"] = true,
    ["global_newgame_template_local_items"] = true,
    ["global_newgame_template_ammo"] = true,
    ["relationship_turret_vs_combine_hate"] = true,
    ["relationship_turret_vs_alyx_like"] = true,
    ["relationship_turret_vs_manhack_hate"] = true,
    ["relationship_combine_vs_turret_hate"] = true,
    ["relationship_alyx_vs_turret_like"] = true,
    ["relationship_turret_vs_player_like"] = true
}

function MAPSCRIPT:PostInit()
    if SERVER then
        local allowClose = false

        GAMEMODE:WaitForInput("door_croom2_gate", "Close", function(ent)
            if allowClose == false then return true end
        end)

        ents.WaitForEntityByName("turret_buddy", function(ent)
            ent:SetKeyValue("spawnflags", "576")
        end, true)

        -- First defense clip, causes glitches if bypassed.
        local pclip1 = ents.Create("func_brush")
        pclip1:SetModel("*17")
        pclip1:SetPos(Vector(-423.9, -3681, 17.21))
        pclip1:SetName("lambda_pclip1")
        pclip1:Spawn()
        pclip1:AddDebugOverlays(bit.bor(OVERLAY_PIVOT_BIT, OVERLAY_BBOX_BIT, OVERLAY_NAME_BIT))
        local pclip2 = ents.Create("func_brush")
        pclip2:SetModel("*17")
        pclip2:SetPos(Vector(-423.9, -3681, 185.21))
        pclip2:SetName("lambda_pclip2")
        pclip2:Spawn()
        pclip2:AddDebugOverlays(bit.bor(OVERLAY_PIVOT_BIT, OVERLAY_BBOX_BIT, OVERLAY_NAME_BIT))
        -- -122.634003 -2595.938477 -239.968750
        local checkpoint1 = GAMEMODE:CreateCheckpoint(Vector(-440.542938, -2845.282227, -239.968750), Angle(0, -90, 0))
        checkpoint1:SetVisiblePos(Vector(-422.728180, -3322.500244, -167.968750))
        local checkpointTrigger1 = ents.Create("trigger_multiple")
        checkpointTrigger1:SetupTrigger(Vector(-122.634003, -2595.938477, -239.968750), Angle(0, 0, 0), Vector(-500, -300, 0), Vector(500, 200, 200))

        checkpointTrigger1.OnEndTouchAll = function(trigger)
            GAMEMODE:SetPlayerCheckpoint(checkpoint1)
            allowClose = true
            TriggerOutputs({{"door_croom2_gate", "Close", 0, ""}})
            trigger:Remove()
            DbgPrint("All players left")
        end

        GAMEMODE:WaitForInput("teleport_alyx_to_croom2", "BeginSequence", function()
            checkpoint1:Reset()
            GAMEMODE:SetPlayerCheckpoint(checkpoint1)
        end)

        -- 1680.254639 -3440.008301 -679.968750
        local checkpoint3 = GAMEMODE:CreateCheckpoint(Vector(1680.254639, -3440.008301, -679.968750), Angle(0, -90, 0))
        local checkpointTrigger3 = ents.Create("trigger_once")
        checkpointTrigger3:SetupTrigger(Vector(1680.254639, -3440.008301, -679.968750), Angle(0, 0, 0), Vector(-50, -50, 0), Vector(50, 50, 100))

        checkpointTrigger3.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint3, activator)
        end

        -- 4161.470215 -3967.863525 -543.968750
        local checkpoint5 = GAMEMODE:CreateCheckpoint(Vector(4779.625488, -4233.572266, -543.968750), Angle(0, 180, 0))
        checkpoint5:SetVisiblePos(Vector(4137.396973, -3976.567871, -543.968750))
        local checkpointTrigger5 = ents.Create("trigger_once")
        checkpointTrigger5:SetupTrigger(Vector(4161.470215, -3967.863525, -543.968750), Angle(0, 0, 0), Vector(-180, -100, 0), Vector(180, 100, 100))

        checkpointTrigger5.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint5, activator)
        end

        -- Second defense, we manipulate the math_counter for the turrets and add an extra input value that fires once all players are there.
        ents.WaitForEntityByName("math_room5_count_turrets", function(ent)
            ent:SetKeyValue("max", "4")
        end)

        local checkpointTrigger6 = ents.Create("trigger_once")
        checkpointTrigger6:SetupTrigger(Vector(4143.243164, -4192.229980, -531.423218), Angle(0, 0, 0), Vector(-500, -700, -30), Vector(700, 420, 100))
        checkpointTrigger6:SetKeyValue("teamwait", "1")

        checkpointTrigger6.OnTrigger = function(ent)
            TriggerOutputs({{"math_room5_count_turrets", "Add", 0, "1"}})
        end

        -- Make sure that alyx will get there.
        ents.WaitForEntityByName("lcs_message_room5_done", function(ent)
            ent:Fire("AddOutput", "OnCompletion logic_room5_assault_finished,Trigger,,10,-1")
            ent:Fire("AddOutput", "OnCompletion logic_room5_assault_finished,Kill,,10.1,-1")
        end)
    end
end

function MAPSCRIPT:PreChangelevel(map, landmark)
    -- Make sure alyx is within the volume .
    local alyx = ents.FindFirstByName("alyx")

    if IsValid(alyx) then
        alyx:SetPos(Vector(4459.584961, -4338.886230, -695.906250))
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

return MAPSCRIPT