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
    ["startobjects"] = true
}

function MAPSCRIPT:PostInit()
    if SERVER then
        -- Figure out a better way to finish this scene.
        ents.RemoveByClass("trigger_once", Vector(-7504, -304, -3344))
    end
end

function MAPSCRIPT:PostPlayerSpawn(ply)
    --DbgPrint("PostPlayerSpawn")
end

function MAPSCRIPT:FindUseEntity(ply, ent)
    if IsValid(ent) and (ent:GetName() == "graveyard_exit_lever_rot" or ent:GetName() == "graveyard_exit_momentary_wheel") then return NULL end
end

return MAPSCRIPT