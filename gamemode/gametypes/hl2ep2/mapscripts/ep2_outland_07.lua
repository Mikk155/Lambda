if SERVER then
    AddCSLuaFile()
end

local function CreateSoundAlias(oldName, newName)
    local soundData = sound.GetProperties(oldName)
    soundData.name = newName
    sound.Add(soundData)
end

CreateSoundAlias("NPC_Advisor.Speak", "NPC_Advisor.Idle")
CreateSoundAlias("NPC_Advisor.ScreenVx02", "NPC_Advisor.Alert")

local MAPSCRIPT = {}
MAPSCRIPT.DefaultLoadout = {
    Weapons = {
        "weapon_lambda_medkit",
        "weapon_physcannon",
        "weapon_crowbar",
        "weapon_pistol",
        "weapon_shotgun",
        "weapon_smg1",
        "weapon_ar2",
        "weapon_crossbow",
        "weapon_357",
        "weapon_frag",
    },
    Ammo = {
        ["XBowBolt"] = 4,
        ["AR2"] = 30,
        ["Pistol"] = 20,
        ["Grenade"] = 5,
        ["SMG1"] = 45,
    },
    Armor = 60,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}
MAPSCRIPT.EntityFilterByName = {
    -- FIXME: Contains alyx.
    --["global_newgame_template_base_items"] = true,
    ["global_newgame_spawner_suit"] = true,
    ["global_newgame_spawner_crowbar"] = true,
    ["global_newgame_spawner_pistol"] = true,
    ["global_newgame_spawner_physcannon"] = true,
    ["global_newgame_template_ammo"] = true,
    ["global_newgame_template_local_items"] = true,
    ["template_barn_vclip"] = true, -- Has a template that doesn't exist.
}

MAPSCRIPT.GlobalStates = {
}

MAPSCRIPT.Checkpoints = {
    {
        Pos = Vector(-10035.7, -9843.1, 32.7),
        Ang = Angle(0, 0, 0),
        Trigger = {
            Pos = Vector(-10035.7, -9843.1, 32.7),
            Mins = Vector(-80, -30, 0),
            Maxs = Vector(80, 30, 70)
        },
        Vehicle = {
            Pos = Vector(-9846, -10604, 118.5),
            Ang = Angle(0, -100, 0),
        }
    },
}

function MAPSCRIPT:PostInit()
    -- Create cvehicle_barn1 for all players.
    local datacvehicle_barn1 = game.FindEntityInMapData("cvehicle_barn1")
    if datacvehicle_barn1 ~= nil then
        for i = 1, game.MaxPlayers() - 1 do
            local dupe = ents.CreateFromData(datacvehicle_barn1)
            dupe:Spawn()
            dupe:Activate()
        end
    else
        print("Unable to find cvehicle_barn1 in map data!")
    end

    -- Don't draw players when they are in the vehicle.
    for _, veh in pairs(ents.FindByName("cvehicle_barn1")) do
        veh:Fire("AddOutput", "PlayerOn !activator,DisableDraw,,0.0,-1")
        veh:Fire("AddOutput", "PlayerOff !activator,EnableDraw,,0.0,-1")
    end

    GAMEMODE:WaitForInput("cvehicle_barn1", "EnterVehicle", function(ent, caller)
        local vehicles = ents.FindByName("cvehicle_barn1")
        for _, v in pairs(util.GetAllPlayers()) do
            if v:Alive() == false then
                continue
            end

            v:SetNoDraw(true)

            local nextVehicle = vehicles[1]
            table.remove(vehicles, 1)

            if IsValid(nextVehicle) then
                v:EnterVehicle(nextVehicle)
            end
        end

        -- Suppress this input.
        return true
    end)

    -- Prevent the deletion of the vehicle.
    GAMEMODE:WaitForInput("jeep", "Kill", function(ent, caller)
        return true
    end)

    -- Resize the trigger and make it wait for all players.
    ents.WaitForEntityByName("trigger_alyx_start_advisor_scene", function(ent)
        ent:SetupTrigger(
            Vector(-9600, -9708, 125),
            Angle(0, 0, 0),
            Vector(-520, -260, 0),
            Vector(350, 260, 180),
            false
        )
        ent:SetKeyValue("teamwait", "1")
    end)
end

function MAPSCRIPT:OnJalopyCreated(jalopy)
    local companionController = ents.Create("lambda_vehicle_companion")
    local name = "lambda_vc_" .. tostring(jalopy:EntIndex())
    companionController:SetName(name)
    companionController:SetPos(jalopy:GetPos())
    companionController:SetKeyValue("CompanionName", "alyx")
    companionController:SetParent(jalopy)
    companionController:Spawn()

    jalopy:ClearAllOutputs("PlayerOff")
    jalopy:ClearAllOutputs("PlayerOn")

    jalopy:Fire("AddOutput", "PlayerOn " .. name .. ",OnPlayerVehicleEnter,,0,-1")
    jalopy:Fire("AddOutput", "PlayerOff " .. name .. ",OnPlayerVehicleExit,,0,-1")
end

return MAPSCRIPT