local _, ns = ...

---
-- The order of the data represents the order presented by the
-- Addon's Interface.
--
-- Zones:
--   id = Map ID,
--   covenant = Covenant ID,
--   color = Hex Color,
--   icon = Icon Texture ID,
--   rares = Notable Rares,
--
-- Rares:
--   id = NPC ID,
--   name = NPC Name (need to figure out how to get this from the Blizzard API),
--   quest = Quest ID(s) for completion,
--   waypoint = {X Coordinate, Y Coordinate},
--   covenantRequired = Requires the Zone's Covenant to summon
--   items = Notable Items Dropped
--
-- Items:
--   id = Item ID,
--   mount = Mount ID (if mount),
--   achievement = Achievement ID (if associated),
---

-- Builds Covenants
function covenants()
    return
end

ns.data = {
    expansions = {
        ["Shadowlands"] = {
            notes = {
                "This is very much a work-in-progress!",
                "Message |cff9b59b6WaldenPond#0001|r on Discord for feedback or help.",
                "And make sure you're in the RUIN Discord! |cff0099ffhttps://discord.gg/ruin|r"
            },
            npcs = {
            },
            zones = {
                {
                    -- Maldraxxus
                    id = 1536,
                    covenant = 4,
                    color = "40bf40",
                    icon = "3257749",
                    rares = {
                        {
                            hidden = true,
                            id = 173104,
                            name = "Mortanis",
                            quest = 61816,
                            waypoint = {32.3, 67.0},
                            items = {
                                {
                                    id = 184133,
                                },
                                {
                                    id = 184140,
                                },
                                {
                                    id = 184173,
                                },
                                {
                                    id = 184128,
                                },
                                {
                                    id = 184135,
                                },
                                {
                                    id = 184143,
                                },
                                {
                                    id = 183295,
                                },
                                {
                                    id = 183386,
                                },
                                {
                                    id = 183341,
                                },
                            },
                        },
                        {
                            id = 162853,
                            name = "Theater of Pain",
                            quest = 62786,
                            waypoint = {28.9, 51.3},
                            items = {
                                {
                                    id = 184062,
                                    mount = 1437,
                                },
                            },
                        },
                        {
                            id = 157226,
                            name = "Pool of Mixed Monstrosities",
                            quest = {61718, 61719, 61720, 61721, 61722, 61723, 61724},
                            waypoint = {61.9, 76.8},
                            items = {
                                {
                                    id = 183903,
                                    achievement = 14721,
                                },
                            },
                        },
                        {
                            id = 157309,
                            name = "Violet Mistake",
                            quest = 61720,
                            waypoint = {61.9, 76.8},
                            items = {
                                {
                                    id = 182079,
                                    mount = 1410,
                                },
                            },
                        },
                        {
                            id = 48859,
                            name = "Oily Invertebrate",
                            quest = 61724,
                            waypoint = {61.9, 76.8},
                            items = {
                                {
                                    id = 184155,
                                    quest = 62804,
                                },
                            },
                        },
                        {
                            id = 174108,
                            name = "Necromatic Anomaly",
                            quest = 58889,
                            waypoint = {72.4, 28.6},
                            items = {
                                {
                                    id = 181810,
                                },
                            },
                        },
                        {
                            id = 162727,
                            name = "Bubbleblood",
                            quest = 58870,
                            waypoint = {51.9, 36.4},
                            items = {
                                {
                                    id = 184154,
                                },
                                {
                                    id = 184476,
                                },
                            },
                        },
                        {
                            id = 159886,
                            name = "Sister Chelicerae",
                            quest = 58003,
                            waypoint = {55.0, 23.0},
                            items = {
                                {
                                    id = 184289,
                                },
                                {
                                    id = 181172,
                                    pet = 2948,
                                },
                            },
                        },
                        {
                            id = 162669,
                            name = "Devour'us",
                            quest = 58835,
                            waypoint = {44.0, 29.5},
                            items = {
                                {
                                    id = 184178,
                                },
                            },
                        },
                        {
                            id = 157058,
                            name = "Corpsecutter Moroc",
                            quest = 58335,
                            waypoint = {26.7, 26.5},
                            items = {
                                {
                                    id = 184177,
                                },
                                {
                                    id = 184176,
                                },
                            },
                        },
                        {
                            id = 162741,
                            name = "Gieger",
                            quest = 58872,
                            waypoint = {31.5, 35.3},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 182080,
                                    mount = 1411,
                                },
                                {
                                    id = 184298,
                                },
                            },
                        },
                        {
                            id = 157125,
                            name = "Zargox the Reborn",
                            quest = 59290,
                            waypoint = {28.9, 51.3},
                            items = {
                                {
                                    id = 181804,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            id = 162819,
                            name = "Warbringer Mal'korak",
                            quest = 58889,
                            waypoint = {33.6, 80.4},
                            items = {
                                {
                                    id = 182085,
                                    mount = 1372,
                                },
                            },
                        },
                        {
                            id = 162690,
                            name = "Nerissa Heartless",
                            quest = 58851,
                            waypoint = {66.0, 35.7},
                            items = {
                                {
                                    id = 182084,
                                    mount = 1373,
                                },
                            },
                        },
                        {
                            id = 162586,
                            name = "Tahonta",
                            quest = 58783,
                            waypoint = {44.0, 51.1},
                            items = {
                                {
                                    id = 182075,
                                    mount = 1366,
                                    covenantOnly = true,
                                },
                            },
                        },
                    }
                },
                {
                    -- Revendreth
                    id = 1525,
                    covenant = 2,
                    color = "ff4040",
                    icon = "3257751",
                    rares = {
                        {
                            hidden = true,
                            id = 167526,
                            name = "Nurgash Muckformed",
                            -- quest = 61816,
                            waypoint = {27.6, 14.6},
                            items = {
                                {
                                    id = 184137,
                                },
                                {
                                    id = 184131,
                                },
                                {
                                    id = 184130,
                                },
                                {
                                    id = 184134,
                                },
                                {
                                    id = 184171,
                                },
                                {
                                    id = 184144,
                                },
                                {
                                    id = 182638,
                                },
                                {
                                    id = 183215,
                                },
                                {
                                    id = 183376,
                                },
                            },
                        },
                        {
                            id = 166521,
                            name = "Famu the Infinite",
                            quest = 59869,
                            waypoint = {62.2, 47.0},
                            items = {
                                {
                                    id = 180582,
                                    mount = 1379,
                                },
                            },
                        },
                        {
                            id = 165290,
                            name = "Harika the Horrid",
                            quest = 59612,
                            waypoint = {45.8, 78.9},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 180461,
                                    mount = 1310,
                                },
                            },
                        },
                        {
                            id = 166679,
                            name = "Hopecrusher",
                            quest = 59900,
                            waypoint = {52.0, 51.6},
                            items = {
                                {
                                    id = 180581,
                                    mount = 1298,
                                },
                            },
                        },
                        {
                            id = 159496,
                            name = "Forgemaster Madalav",
                            quest = 61618,
                            waypoint = {32.6, 15.4},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 180939,
                                },
                            },
                        },
                        {
                            id = 160857,
                            name = "Sire Ladinas",
                            quest = 58263,
                            waypoint = {34.0, 55.4},
                            items = {
                                {
                                    id = 180873,
                                },
                            },
                        },
                        {
                            id = 160821,
                            name = "Worldedge Gorger",
                            quest = 58259,
                            waypoint = {38.6, 72.2},
                            items = {
                                {
                                    id = 182589,
                                    mount = 1391,
                                },
                            },
                        },
                    }
                },
                {
                    -- The Maw
                    id = 1543,
                    color = "e5cc80",
                    icon = "3743739",
                    rares = {
                        {
                            hidden = true,
                            id = 174827,
                            name = "Gorged Shadehound",
                            -- quest = 61124,
                            waypoint = {53.6, 78.6},
                            items = {
                                {
                                    id = 184167,
                                    mount = 1304,
                                },
                            },
                        },
                        {
                            id = 162849,
                            name = "Morguliax <Lord of Decapitation>",
                            quest = 60987,
                            waypoint = {16.6, 50.6},
                            items = {
                                {
                                    id = 184292,
                                },
                            },
                        },
                        {
                            id = 172577,
                            name = "Orophea",
                            quest = 61519,
                            waypoint = {23.8, 21.6},
                            items = {
                                {
                                    id = 181794,
                                },
                            },
                        },
                        {
                            id = 157833,
                            name = "Borr-Geth",
                            quest = 57469,
                            waypoint = {39.6, 40.8},
                            items = {
                                {
                                    id = 184312,
                                },
                            },
                        },
                    }
                },
                {
                    -- Bastion
                    id = 1533,
                    covenant = 1,
                    color = "68ccef",
                    icon = "3257748",
                    rares = {
                        {
                            hidden = true,
                            id = 167524,
                            name = "Valinor, the Light of Eons",
                            quest = 61813,
                            waypoint = {26.6, 22.8},
                            items = {
                                {
                                    id = 184170,
                                },
                                {
                                    id = 184136,
                                },
                                {
                                    id = 184125,
                                },
                                {
                                    id = 184132,
                                },
                                {
                                    id = 184139,
                                },
                                {
                                    id = 184141,
                                },
                                {
                                    id = 183311,
                                },
                                {
                                    id = 183325,
                                },
                                {
                                    id = 183353,
                                },
                            }
                        },
                        {
                            id = 170548,
                            name = "Sundancer",
                            -- quest = ?????,
                            waypoint = {60.3, 79.7},
                            items = {
                                {
                                    id = 180773,
                                    mount = 1307,
                                },
                            },
                        },
                        {
                            id = 167078,
                            name = "Wingflayer the Cruel",
                            quest = 60314,
                            waypoint = {40.7, 52.9},
                            items = {
                                {
                                    id = 182749,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            id = 170623,
                            name = "Dark Watcher",
                            quest = 60883,
                            waypoint = {27.7, 30.0},
                            items = {
                                {
                                    id = 184297,
                                },
                            },
                        },
                        {
                            id = 156339,
                            name = "Orstus & Sotiros",
                            quest = 61634,
                            waypoint = {22.6, 22.9},
                            items = {
                                {
                                    id = 184365,
                                },
                            },
                        },
                        {
                            id = 170832,
                            name = "Ascended Council",
                            quest = 60977,
                            waypoint = {53.5, 88.2},
                            items = {
                                {
                                    id = 183741,
                                    mount = 1426,
                                },
                            },
                        },
                        {
                            id = 171009,
                            name = "Enforcer Aegeon",
                            quest = 60998,
                            waypoint = {50.8, 19.6},
                            items = {
                                {
                                    id = 184404,
                                },
                            },
                        },
                        {
                            id = 171008,
                            name = "Unstable Memory",
                            quest = 60997,
                            waypoint = {43.4, 25.2},
                            items = {
                                {
                                    id = 184413,
                                },
                            },
                        },
                    }
                },
                {
                    -- Ardenweald
                    id = 1565,
                    covenant = 3,
                    color = "8b55d7",
                    icon = "3257750",
                    rares = {
                        {
                            hidden = true,
                            id = 167527,
                            name = "Oranomonos the Everbranching",
                            quest = 61815,
                            waypoint = {20.6, 63.6},
                            items = {
                                {
                                    id = 184127,
                                },
                                {
                                    id = 184129,
                                },
                                {
                                    id = 184172,
                                },
                                {
                                    id = 184126,
                                },
                                {
                                    id = 184138,
                                },
                                {
                                    id = 184142,
                                },
                                {
                                    id = 183238,
                                },
                                {
                                    id = 183261,
                                },
                                {
                                    id = 183274,
                                },
                            },
                        },
                        {
                            id = 164112,
                            name = "Humon'gozz",
                            quest = 59157,
                            waypoint = {32.4, 30.4},
                            items = {
                                {
                                    id = 182650,
                                    mount = 1415,
                                    guaranteed = true,
                                },
                            },
                        },
                        {
                            id = 168647,
                            name = "Valfir the Unrelenting",
                            quest = 61632,
                            waypoint = {30.6, 55.0},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 180730,
                                    mount = 1393,
                                },
                            },
                        },
                        {
                            id = 164107,
                            name = "Gormtamer Tizo",
                            quest = 59145,
                            waypoint = {26.4, 54.3},
                            items = {
                                {
                                    id = 180725,
                                    mount = 1362,
                                    guaranteed = true,
                                },
                            },
                        },
                        {
                            id = 168135,
                            name = "Night Mare",
                            quest = 60306,
                            waypoint = {62.2, 53.9},
                            items = {
                                {
                                    id = 180728,
                                    mount = 1306,
                                    covenantOnly = true,
                                    guaranteed = true,
                                },
                            },
                        },
                        {
                            id = 160448,
                            name = "Hunter Vivian",
                            quest = 59221,
                            waypoint = {67.1, 24.6},
                            items = {
                                {
                                    id = 179596,
                                },
                            },
                        },
                    }
                },
            },
        },
    },
}
