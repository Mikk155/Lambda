if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.PlayersLocked = false
MAPSCRIPT.DefaultLoadout = {
    Weapons = {"weapon_lambda_medkit", "weapon_crowbar", "weapon_pistol", "weapon_smg1"},
    Ammo = {
        ["Pistol"] = 118,
        ["SMG1"] = 90
    },
    Armor = 0,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}
MAPSCRIPT.EntityFilterByName = {
    ["global_newgame_entmaker"] = true,
    ["relay_rockfall_start"] = true -- Don't do that, its trivial.
}

local function FreezeEntitiesAt(pos, extent)
    local foundEnts = ents.FindInBox(pos - extent, pos + extent)
    for _, v in pairs(foundEnts) do
        local physObj = v:GetPhysicsObject()
        if IsValid(physObj) then
            physObj:EnableMotion(false)
        end
    end
end

function MAPSCRIPT:PostInit()
    if SERVER then
        local checkpoint1 = GAMEMODE:CreateCheckpoint(Vector(4149.820313, 3446.334229, -466.530853), Angle(0, -66, 0))
        checkpoint1:SetVisiblePos(Vector(4240.543945, 3220.031982, -473.430939))
        local checkpointTrigger1 = ents.Create("trigger_once")
        checkpointTrigger1:SetupTrigger(Vector(4236.846191, 3261.946289, -474.814972), Angle(0, 0, 0), Vector(-100, -100, 0), Vector(100, 100, 180))
        checkpointTrigger1.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint1, activator)
        end

        local checkpoint2 = GAMEMODE:CreateCheckpoint(Vector(7352.527344, 1597.768555, -447.968750), Angle(0, -90, 0))
        checkpoint2:SetVisiblePos(Vector(6758.199219, 1572.104248, -447.968750))
        local checkpointTrigger2 = ents.Create("trigger_once")
        checkpointTrigger2:SetupTrigger(Vector(6770.862793, 1569.191040, -447.968750), Angle(0, 0, 0), Vector(-100, -100, 0), Vector(100, 100, 180))
        checkpointTrigger2.OnTrigger = function(_, activator)
            GAMEMODE:SetPlayerCheckpoint(checkpoint2, activator)
        end

        ents.WaitForEntityByName(
            "rotate_guncave_exit_wheel",
            function(ent)
                ent:Fire("Unlock")
                ent:Fire("AddOutput", "OnPressed relay_airboat_gateopen,Trigger")
                ent:Fire("AddOutput", "OnPressed ss_arlene_opengate,Kill") -- In case the player opens it dont play the scene.
            end
        )

        -- Disable motion of some entities, they are odd to walk on in multiplayer.
        FreezeEntitiesAt(Vector(4172.168457, 5346.647461, -124.435822), Vector(10, 10, 10))
        FreezeEntitiesAt(Vector(4397.086914, 5241.035645, -121.793793), Vector(10, 10, 10))
        FreezeEntitiesAt(Vector(4246.002441, 4931.557129, -121.530907), Vector(10, 10, 10))
    end
end

return MAPSCRIPT