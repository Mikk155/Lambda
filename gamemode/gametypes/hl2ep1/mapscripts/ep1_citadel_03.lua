if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.DefaultLoadout = {
    Weapons = {"weapon_lambda_medkit", "weapon_physcannon"},
    Ammo = {},
    Armor = 0,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}
MAPSCRIPT.EntityFilterByName = {
    ["global_newgame_spawner_suit"] = true,
    ["global_newgame_spawner_physcannon"] = true,
    ["trigger_fall"] = true,
    ["trigger_fall_2"] = true,
    ["trigger_startmonitor_scene_1"] = true,
    ["Trigger_lift"] = true,
    ["core_airlock_close"] = true
}

MAPSCRIPT.GlobalStates = {
    ["super_phys_gun"] = GLOBAL_ON
}

MAPSCRIPT.ImportantPlayerNPCNames = {
    ["Mossman2"] = true
}

MAPSCRIPT.Checkpoints = {
    {
        Pos = Vector(3799, 12449, 4745),
        Ang = Angle(0, 0, 0),
        Trigger = {
            Pos = Vector(3554, 12529, 4801),
            Mins = Vector(-28, -37, -65),
            Maxs = Vector(28, 37, 65)
        }
    },
    {
        Pos = Vector(3035, 11112, 5001),
        Ang = Angle(0, 0, 0),
        Trigger = {
            Pos = Vector(3096, 11194, 5054),
            Mins = Vector(-48, -26, -64),
            Maxs = Vector(48, 26, 64)
        }
    },
    {
        Pos = Vector(3056, 12920, 5513),
        Ang = Angle(0, 0, 0),
        Trigger = {
            Pos = Vector(3080, 12666.6, 5613.5),
            Mins = Vector(-88, -16, -115),
            Maxs = Vector(88, 16, 115)
        }
    },
    {
        Pos = Vector(1098, 12810, 5318),
        Ang = Angle(0, 0, 0),
        Trigger = {
            Pos = Vector(1376, 12816, 5364),
            Mins = Vector(-80, -80, -80),
            Maxs = Vector(80, 80, 80)
        }
    }
}

function MAPSCRIPT:PostInit()
    if SERVER then
        local multipleTrigger = ents.FindByPos(Vector(424, 12164, 5408), "trigger_multiple")
        for k, v in pairs(multipleTrigger) do
            v:Remove()
        end

        local hurtTrigger = ents.Create("trigger_hurt")
        hurtTrigger:SetupTrigger(Vector(2768, 12144, 2896), Angle(0, 0, 0), Vector(-896, -976, -896), Vector(896, 976, 896))
        hurtTrigger:SetKeyValue("damagetype", "1024")
        hurtTrigger:SetKeyValue("damage", "200")
        local doorCloseTrigger = ents.Create("trigger_once")
        doorCloseTrigger:SetupTrigger(Vector(424, 12164, 5408), Angle(0, 0, 0), Vector(-544, -208, -96), Vector(544, 208, 96))
        doorCloseTrigger:SetKeyValue("teamwait", "1")
        doorCloseTrigger:SetKeyValue("showwait", "0")
        doorCloseTrigger:Fire("AddOutput", "OnTrigger trigger_alyx_close_airlock,Enable,0.0,-1")
        doorCloseTrigger.OnTrigger = function(_, activator)
            local checkpoint = GAMEMODE:CreateCheckpoint(Vector(-112, 12164, 5316))
            GAMEMODE:SetPlayerCheckpoint(checkpoint, activator)
        end

        local monitorSceneTrigger = ents.Create("trigger_once")
        monitorSceneTrigger:SetupTrigger(Vector(1200, 11676, 5536), Angle(0, 0, 0), Vector(-208, -156, -222), Vector(208, 156, 222))
        monitorSceneTrigger:SetName("trigger_startmonitor_scene_1")
        monitorSceneTrigger:SetKeyValue("StartDisabled", "1")
        monitorSceneTrigger:SetKeyValue("teamwait", "1")
        monitorSceneTrigger:Fire("AddOutput", "OnTrigger trigger_door_comb_close,Enable,0.0,-1")
        monitorSceneTrigger:Fire("AddOutput", "OnTrigger lcs_core_control_scene,Start,0.0,1")
        monitorSceneTrigger:Fire("AddOutput", "OnTrigger pclip_door1,Enable,0.0,-1")
        monitorSceneTrigger.OnTrigger = function(_, activator)
            local checkpoint = GAMEMODE:CreateCheckpoint(Vector(1224, 11835, 5317))
            GAMEMODE:SetPlayerCheckpoint(checkpoint, activator)
        end

        local elevator
        ents.WaitForEntityByName(
            "lift_airlock",
            function(ent)
                elevator = ent
            end
        )

        local liftTrigger = ents.Create("trigger_once")
        liftTrigger:SetupTrigger(Vector(1522, 11720, 5312), Angle(0, 0, 0), Vector(-78, -136, -48), Vector(78, 136, 48))
        liftTrigger:SetName("Trigger_lift")
        liftTrigger:SetKeyValue("StartDisabled", "1")
        liftTrigger:SetKeyValue("teamwait", "1")
        liftTrigger:Fire("AddOutput", "OnTrigger lcs_core_control_scene,Resume,0.0,-1")
        liftTrigger:Fire("AddOutput", "OnTrigger Core_lift_doors,Close,0.0,-1")
        liftTrigger.OnTrigger = function(_, activator)
            local checkpoint = GAMEMODE:CreateCheckpoint(Vector(1522, 11720, 5312))
            checkpoint:SetParent(elevator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint, activator)
        end

        local multipleTrigger2 = ents.FindByPos(Vector(1876.97, 10580.9, 5532), "trigger_multiple")
        for k, v in pairs(multipleTrigger2) do
            v:Remove()
        end

        local tracktrain_elevator
        ents.WaitForEntityByName(
            "Train_lift_TP",
            function(ent)
                tracktrain_elevator = ent
            end
        )

        local liftTrigger2 = ents.Create("trigger_once")
        liftTrigger2:SetupTrigger(Vector(1857.5, 10507.5, 4988), Angle(0, 75, 0), Vector(-80, -100, -25), Vector(80, 100, 25))
        liftTrigger2:SetKeyValue("teamwait", "1")
        liftTrigger2:Fire("AddOutput", "OnTrigger Train_lift_TP,StartForward,0.0,-1")
        liftTrigger2:Fire("AddOutput", "OnTrigger enemyfinder_core_breakerroom_2b,Wake,3.0,1")
        liftTrigger2.OnTrigger = function(_, activator)
            local checkpoint = GAMEMODE:CreateCheckpoint(Vector(1857.5, 10507.5, 4988))
            checkpoint:SetParent(tracktrain_elevator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint, activator)
        end

        local elevator_exit
        ents.WaitForEntityByName(
            "Train_lift_coreexit",
            function(ent)
                elevator_exit = ent
            end
        )

        local multipleTrigger3 = ents.FindByPos(Vector(1152, 13654, 5312), "trigger_multiple")
        for k, v in pairs(multipleTrigger3) do
            v:Remove()
        end

        local liftTrigger3 = ents.Create("trigger_once")
        liftTrigger3:SetupTrigger(Vector(1152, 13658, 5344), Angle(0, 0, 0), Vector(-95, -75, -64), Vector(95, 75, 64))
        liftTrigger3:SetKeyValue("teamwait", "1")
        liftTrigger3:Fire("AddOutput", "OnTrigger relay_powerdown_sequence,Trigger,0.0,-1")
        liftTrigger3.OnTrigger = function(_, activator)
            local checkpoint = GAMEMODE:CreateCheckpoint(Vector(1152, 13632, 5285))
            checkpoint:SetParent(elevator_exit)
            GAMEMODE:SetPlayerCheckpoint(checkpoint, activator)
        end
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
end

return MAPSCRIPT