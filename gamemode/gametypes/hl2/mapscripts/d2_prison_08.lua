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
    ["global_newgame_template_base_items"] = true,
    ["global_newgame_template_local_items"] = true,
    ["global_newgame_template_ammo"] = true,
    ["NClip_sec_tp_door_1"] = true,
    ["PClip_sec_tp_door_1"] = true
}

function MAPSCRIPT:PostInit()
    if SERVER then
        -- setpos -497.127838 29.422707 576.030090;setang 1.708000 -178.566528 0.000000
        local checkpoint1 = GAMEMODE:CreateCheckpoint(Vector(-497.127838, 29.422707, 512.03009), Angle(0, 0, 0))
        local checkpointTrigger1 = ents.Create("trigger_once")
        checkpointTrigger1:SetupTrigger(Vector(-497.127838, 29.422707, 576.030090), Angle(0, 0, 0), Vector(-100, -250, 0), Vector(100, 250, 200))

        checkpointTrigger1.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint1, activator)
        end

        -- -709.431885 820.863708 960.031250
        local triggerPoint1 = false

        GAMEMODE:WaitForInput("brush_bigdoor_ALYXClip_1", "Enable", function(ent)
            if triggerPoint1 == false then return true end
        end)

        GAMEMODE:WaitForInput("trigger_teleport01", "Enable", function(ent)
            if triggerPoint1 == false then return true end
        end)

        -- -956.561707 820.578613 960.031250
        local checkpoint3 = GAMEMODE:CreateCheckpoint(Vector(-956.561707, 820.578613, 960.031250), Angle(0, 0, 0))
        local checkpointTrigger3 = ents.Create("trigger_once")
        checkpointTrigger3:SetupTrigger(Vector(-709.431885, 820.863708, 960.031250), Angle(0, 0, 0), Vector(-400, -300, -10), Vector(500, 130, 250))
        checkpointTrigger3:SetKeyValue("teamwait", "1")
        checkpointTrigger3.OnTrigger = function(_, activator)
            triggerPoint1 = true
            TriggerOutputs({{"brush_bigdoor_ALYXClip_1", "Enable", 0, ""}, {"trigger_teleport01", "Enable", 0, ""}})
            GAMEMODE:SetPlayerCheckpoint(checkpoint3, activator)
        end

        ents.WaitForEntityByName("trigger_teleport01", function(ent)
            ent:ResizeTriggerBox(Vector(-330, -300, -100), Vector(500, 50, 200))
        end)

        --ent:SetKeyValue("teamwait", "1")
        -- Inverse
        -- -579.983948 563.455078 928.031250
        local checkpoint2 = GAMEMODE:CreateCheckpoint(Vector(-579.983948, 563.455078, 928.031250), Angle(0, 0, 0))
        checkpoint2:SetVisiblePos(Vector(-442.803680, 529.028320, 928.031250))
        local checkpointTrigger2 = ents.Create("trigger_multiple")
        checkpointTrigger2:SetupTrigger(Vector(-709.431885, 820.863708, 960.031250), Angle(0, 0, 0), Vector(-400, -240, -10), Vector(500, 180, 250))
        checkpointTrigger2:SetKeyValue("StartDisabled", "1")

        checkpointTrigger2.OnEndTouchAll = function(trigger, activator)
            TriggerOutputs({{"combine_door_1", "SetAnimation", 0, "Close"}, {"logic_apply_relationships_1", "Trigger", 0, ""}, {"sec_room_door_1", "Close", 0, ""}, {"prop_camerasx", "Kill", 0, ""}, {"combine_door_1", "SetAnimation", 0, "idle_closed"}})
            trigger:Remove()
            GAMEMODE:SetPlayerCheckpoint(checkpoint2, activator)
        end

        -- Replace trigger with inverse one.
        ents.WaitForEntityByName("trigger_close_console_door_1", function(ent)
            checkpointTrigger2:SetName("trigger_close_console_door_1")
            ent:Remove()
        end)

        -- Skip alyx closing the door
        ents.WaitForEntityByName("trigger_tp_scene_start", function(ent)
            ent:Fire("AddOutput", "OnTrigger relayAnim_PodExtractor_extract,Trigger,,5,-1")
        end)

        ents.WaitForEntityByName("lcs_np_teleport04", function(ent)
            ent:Remove()
            ents.WaitForEntityByName("lcs_np_teleport05", function(ent2)
                ent2:SetName("lcs_np_teleport04")
                ent2:Fire("AddOutput", "OnTrigger1")
            end)
        end)

        ents.WaitForEntityByName("trigger_teleport_player_enter_1", function(ent)
            ent:ResizeTriggerBox(Vector(-30, -30, 0), Vector(30, 30, 100))
            ent:SetKeyValue("teamwait", "1")
        end)
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

return MAPSCRIPT