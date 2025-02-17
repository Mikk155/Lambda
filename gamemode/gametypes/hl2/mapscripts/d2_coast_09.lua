if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.PlayersLocked = false

MAPSCRIPT.DefaultLoadout = {
    Weapons = {"weapon_lambda_medkit", "weapon_crowbar", "weapon_pistol", "weapon_smg1", "weapon_357", "weapon_physcannon", "weapon_frag", "weapon_shotgun", "weapon_ar2", "weapon_rpg", "weapon_crossbow"},
    Ammo = {
        ["Pistol"] = 118,
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
    ["global_newgame_spawner_ammo"] = true,
    ["global_newgame_template_local_items"] = true,
    ["global_newgame_spawner_suit"] = true,
    ["global_newgame_spawner_crowbar"] = true,
    ["global_newgame_spawner_pistol"] = true,
    ["global_newgame_spawner_physcannon"] = true,
}

MAPSCRIPT.VehicleGuns = true

function MAPSCRIPT:PostInit()
    -- -6397.890625 4632.765625 512.031250
    if SERVER then
        ents.WaitForEntityByName("reload", function(ent)
            ent:Remove()
        end)

        ents.WaitForEntityByName("jeep_lost_in_water", function(ent)
            ent:Remove()
        end)

        ents.WaitForEntityByName("garage_door_1", function(ent)
            ent:SetKeyValue("spawnflags", "2097152")
        end)

        ents.WaitForEntityByName("garage_door_2", function(ent)
            ent:SetKeyValue("spawnflags", "2097152")
        end)

        ents.WaitForEntityByName("garage_door_3", function(ent)
            ent:SetKeyValue("spawnflags", "2097152")
        end)

        -- In case people throw batteries away.
        local function ProtectBattery(ent)
            ent:SetKeyValue("spawnflags", "128")
            local data = game.FindEntityInMapData(ent:GetName())
            local originalPos = util.StringToType(data["origin"], "Vector")
            local originalAng = util.StringToType(data["angles"], "Angle")
            local centerPos = Vector(10211.183594, 8695.581055, -191.968750)

            hook.Add("Tick", ent, function(e2)
                local pos = ent:GetPos()
                local reset = false

                -- Check general bounding distance.
                if pos:Distance(centerPos) >= 1300 then
                    reset = true
                end

                -- Check positions that are unreachable
                local vel = e2:GetVelocity()

                if vel:Length() <= 0.01 then
                    local zDistance = pos.z - centerPos.z

                    if zDistance >= 120 then
                        reset = true
                    end
                end

                if reset == true and pos:Distance(originalPos) > 20 then
                    e2:SetVelocity(Vector(0, 0, 0))
                    e2:SetPos(originalPos)
                    e2:SetAngles(originalAng)
                end
            end)
        end

        ents.WaitForEntityByName("battery", ProtectBattery)
        ents.WaitForEntityByName("battery1", ProtectBattery)
        ents.WaitForEntityByName("battery2", ProtectBattery)
        ents.WaitForEntityByName("battery3", ProtectBattery)
        ents.WaitForEntityByName("battery4", ProtectBattery)
        local checkpoint1 = GAMEMODE:CreateCheckpoint(Vector(-6203.434570, 4812.755859, 512.031250), Angle(0, -90, 0))
        checkpoint1:SetVisiblePos(Vector(-6399.345703, 4662.560059, 512.031250))
        local checkpointTrigger1 = ents.Create("trigger_once")
        checkpointTrigger1:SetupTrigger(Vector(-6397.890625, 4632.765625, 512.031250), Angle(0, 0, 0), Vector(-300, -20, 0), Vector(300, 20, 200))

        checkpointTrigger1.OnTrigger = function(_, activator)
            GAMEMODE:SetVehicleCheckpoint(Vector(-6321.518555, 4750.143066, 532.837036), Angle(0, 180, 0))
            GAMEMODE:SetPlayerCheckpoint(checkpoint1, activator)
        end

        -- 8663.506836 11871.029297 -191.968750
        local checkpoint3 = GAMEMODE:CreateCheckpoint(Vector(8648.458008, 11745.508789, -196.678345), Angle(0, -50, 0))
        local checkpointTrigger3 = ents.Create("trigger_once")
        checkpointTrigger3:SetupTrigger(Vector(8663.506836, 11871.029297, -191.968750), Angle(0, 0, 0), Vector(-50, -600, 0), Vector(50, 450, 200))

        checkpointTrigger3.OnTrigger = function(_, activator)
            GAMEMODE:SetVehicleCheckpoint(Vector(8699.614258, 11645.158203, -192.527618), Angle(0, -90, 0))
            GAMEMODE:SetPlayerCheckpoint(checkpoint3, activator)
        end
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

return MAPSCRIPT