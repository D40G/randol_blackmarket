Config = {}

Config.Locations = {        -- Locations of where the ped spawns. Chosen randomly every night at 22:00. Add as many as you like.
    [1] = vector4(247.72, -34.56, 73.99, 30.18),
    [2] = vector4(2545.28, 2592.14, 36.96, 114.09),
    [3] = vector4(1862.15, 3856.72, 35.27, 338.39),
    [4] = vector4(-406.47, -1682.39, 18.19, 145.91),
}

Config.Model = 'cs_joeminuteman' -- The model of the ped.


Config.Goodies = {
    label = "Blackmarket",
    slots = 10,
    items = {
        [1] = {
            name = "weapon_microsmg",
            price = 28000,
            amount = 5,
            info = {},
            type = "item",
            slot = 1,
        },
        [2] = {
            name = "weapon_assaultrifle",
            price = 33000,
            amount = 5,
            info = {},
            type = "item",
            slot = 2,
        },
        [3] = {
            name = "weapon_pistol_mk2",
            price = 3800,
            amount = 5,
            info = {},
            type = "item",
            slot = 3,
        },
        [4] = {
            name = "weapon_combatpistol",
            price = 15000,
            amount = 5,
            info = {},
            type = "item",
            slot = 4,
        },
        [5] = {
            name = "thermite",
            price = 1000,
            amount = 10,
            info = {},
            type = "item",
            slot = 5,
        },
        [6] = {
            name = "smg_ammo",
            price = 150,
            amount = 35,
            info = {},
            type = "item",
            slot = 6,
        },
        [7] = {
            name = "oxy",
            price = 150,
            amount = 50,
            info = {},
            type = "item",
            slot = 7,
        },
        [8] = {
            name = "rifle_ammo",
            price = 250,
            amount = 35,
            info = {},
            type = "item",
            slot = 8,
        },
        [9] = {
            name = "trojan_usb",
            price = 2000,
            amount = 5,
            info = {},
            type = "item",
            slot = 9,
        },
        [10] = {
            name = "weapon_heavypistol",
            price = 11000,
            amount = 5,
            info = {},
            type = "item",
            slot = 10,
        }
    }
}


---------------------
-- SHOP OPEN/CLOSE --
---------------------

Config.Open = 22
Config.Close = 5 
