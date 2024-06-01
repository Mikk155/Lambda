if SERVER then
    AddCSLuaFile()
end

local MAPSCRIPT = {}
MAPSCRIPT.DefaultLoadout = {
    Weapons = {
        "weapon_lambda_medkit",
        "weapon_physcannon",
        "weapon_frag",
        "weapon_pistol",
        "weapon_crowbar",
        "weapon_crossbow",
        "weapon_ar2",
        "weapon_357",
        "weapon_shotgun",
        "weapon_smg1",
    },
    Ammo = {
        ["XBowBolt"] = 4,
        ["AR2"] = 50,
        ["lambda_health"] = 1,
        ["Buckshot"] = 30,
        ["Grenade"] = 3,
        ["357"] = 6,
        ["SMG1"] = 90,
    },
    Armor = 45,
    HEV = true
}

MAPSCRIPT.InputFilters = {}
MAPSCRIPT.EntityFilterByClass = {}
MAPSCRIPT.EntityFilterByName = {
    ["spawnitems"] = true,
}

MAPSCRIPT.GlobalStates = {
}

MAPSCRIPT.Checkpoints = {
}

function MAPSCRIPT:PostInit()
    print("-- Incomplete mapscript --")
end

return MAPSCRIPT