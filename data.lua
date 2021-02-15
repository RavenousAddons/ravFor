local _, ns = ...

---
--  Covenants:
--    Covenant IDs:
--      color = Hex Color,
--      icon = Icon Texture ID,
--  Zones:
--    id = Map ID,
--    covenant = Covenant ID *,
--    color = Hex Color *,
--    icon = Icon Texture ID *,
--    rares = Notable Rares,
--    Rares:
--      name = NPC Name (need to figure out how to get this from the Blizzard API),
--      id = NPC ID,
--      quest = Quest ID(s) for completion,
--      waypoint = {X Coordinate, Y Coordinate},
--      covenantRequired = Requires the Zone's Covenant to summon *
--      items = Notable Items Dropped
--    Items:
--      id = Item ID,
--      mount = Mount ID *,
--      achievement = Achievement ID *,
--  * Optional
---

ns.data = {
    defaults = {
        macro = true,
        showNoDrops = false,
        showOwned = true,
        showGear = true,
        showTransmog = true,
        showMounts = true,
        showPets = true,
        showToys = true,
        showCannotUse = true,
        showReputation = true,
    },
    expansions = {
        ["Shadowlands"] = {
            zones = {
                {
                    -- The Maw
                    id = 1543,
                    color = "e5cc80",
                    icon = "3743739",
                    currency = 1767,
                    faction = 2432,
                    rares = {
                        {
                            hidden = true,
                            name = "Gorged Shadehound",
                            id = 174827,
                            waypoint = {53.6, 78.6},
                            items = {
                                {
                                    id = 184167,
                                    mount = 1304,
                                },
                            },
                        },
                        {
                            name = "Borr-Geth",
                            id = 157833,
                            quest = 57469,
                            waypoint = {39.6, 40.8},
                            reputation = 100,
                            items = {
                                {
                                    id = 184312,
                                    toy = true,
                                },
                            },
                        },
                        {
                            name = "Eternas the Tormentor",
                            id = 154330,
                            quest = 57509,
                            waypoint = {19.2, 46.0},
                            reputation = 80,
                            items = {
                                {
                                    id = 183407,
                                    pet = 3037,
                                },
                            },
                        },
                        {
                            name = "Morguliax <Lord of Decapitation>",
                            id = 162849,
                            quest = 60987,
                            waypoint = {16.6, 50.6},
                            reputation = 100,
                            items = {
                                {
                                    id = 184292,
                                    toy = true,
                                },
                            },
                        },
                        {
                            name = "Apholeias, Herald of Loss",
                            id = 170301,
                            quest = 60788,
                            waypoint = {19.6, 41.8},
                            reputation = 100,
                            items = {
                                {
                                    id = 184106,
                                    item = true,
                                },
                                {
                                    id = 182327,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Orophea",
                            id = 172577,
                            quest = 61519,
                            waypoint = {23.8, 21.6},
                            reputation = 80,
                            items = {
                                {
                                    id = 181794,
                                    toy = true,
                                },
                            },
                        },
                        {
                            name = "Adjutant Dekaris",
                            id = 157964,
                            quest = 57482,
                            waypoint = {25.8, 31.2},
                            reputation = 80,
                        },
                        {
                            name = "Conjured Death",
                            id = 171317,
                            quest = 61106,
                            waypoint = {27.8, 13.6},
                            reputation = 80,
                            items = {
                                {
                                    id = 183887,
                                },
                            },
                        },
                        {
                            name = "Darithis the Bleak",
                            id = 160770,
                            quest = 62281,
                            waypoint = {61.0, 48.6},
                            reputation = 100,
                        },
                        {
                            name = "Darklord Taraxis",
                            id = 158025,
                            quest = 62282,
                            waypoint = {48.8, 81.4},
                            reputation = 80,
                        },
                        {
                            name = "Dolos <Death's Knife>",
                            id = 170711,
                            quest = 60909,
                            waypoint = {28.2, 60.6},
                            reputation = 100,
                        },
                        {
                            name = "Eketra <The Impaler>",
                            id = 170774,
                            quest = 60915,
                            waypoint = {23.6, 53.2},
                            reputation = 100,
                        },
                        {
                            name = "Ekphoras, Herald of Grief",
                            id = 169827,
                            quest = 60666,
                            waypoint = {42.6, 21.0},
                            reputation = 100,
                            items = {
                                {
                                    id = 184105,
                                    item = true,
                                },
                                {
                                    id = 182328,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Exos, Herald of Domination",
                            id = 170303,
                            quest = 62260,
                            waypoint = {21.0, 70.6},
                            reputation = 100,
                            items = {
                                {
                                    id = 184108,
                                    item = true,
                                },
                                {
                                    id = 183066,
                                    item = true,
                                    quest = 63160,
                                },
                                {
                                    id = 183067,
                                    item = true,
                                    quest = 63161,
                                },
                                {
                                    id = 183068,
                                    item = true,
                                    quest = 63162,
                                },
                            },
                        },
                        {
                            name = "Ikras the Devourer",
                            id = 175012,
                            quest = 62788,
                            waypoint = {30.8, 50.0},
                            reputation = 100,
                        },
                        {
                            name = "Nascent Devourer",
                            id = 158278,
                            quest = 57573,
                            waypoint = {45.5, 73.8},
                            reputation = 80,
                        },
                        {
                            name = "Obolos <Prime Adjutant>",
                            id = 164064,
                            quest = 60667,
                            waypoint = {48.8, 18.3},
                            reputation = 80,
                        },
                        {
                            name = "Shadeweaver Zeris",
                            id = 170634,
                            quest = 60884,
                            waypoint = {32.9, 66.5},
                            reputation = 100,
                            items = {
                                {
                                    id = 183066,
                                    item = true,
                                    quest = 63160,
                                },
                                {
                                    id = 183067,
                                    item = true,
                                    quest = 63161,
                                },
                                {
                                    id = 183068,
                                    item = true,
                                    quest = 63162,
                                },
                            },
                        },
                        {
                            name = "Soulforger Rhovus",
                            id = 166398,
                            quest = 60834,
                            waypoint = {36.0, 41.6},
                            reputation = 80,
                        },
                        {
                            name = "Talaporas, Herald of Pain",
                            id = 170302,
                            quest = 60789,
                            waypoint = {28.7,12.0},
                            reputation = 100,
                            items = {
                                {
                                    id = 184107,
                                },
                                {
                                    id = 182326,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Thanassos <Death's Voice>",
                            id = 170731,
                            quest = 60914,
                            waypoint = {27.4, 71.5},
                            reputation = 100,
                        },
                        {
                            name = "Yero the Skittish",
                            id = 172862,
                            quest = 61568,
                            waypoint = {37.4, 62.1},
                            reputation = 80,
                        },
                    },
                },
                {
                    -- Maldraxxus
                    id = 1536,
                    covenant = 4,
                    rares = {
                        {
                            hidden = true,
                            name = "Mortanis",
                            id = 173104,
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
                            name = "Theater of Pain",
                            id = 162853,
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
                            name = "Sabriel the Bonecleaver",
                            id = 168147,
                            quest = 58784,
                            waypoint = {28.9, 51.3},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 181815,
                                    mount = 1370,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Scunner",
                            id = 158406,
                            quest = 58006,
                            waypoint = {62.0, 75.9},
                            items = {
                                {
                                    id = 184287,
                                },
                                {
                                    id = 181267,
                                    pet = 2957,
                                },
                            },
                        },
                        {
                            name = "Pool of Mixed Monstrosities",
                            id = 157226,
                            achievement = 14721,
                            waypoint = {61.9, 76.8},
                            items = {
                                {
                                    id = 183903,
                                },
                            },
                        },
                        {
                            name = "Violet Mistake",
                            id = 157309,
                            quest = 61720,
                            waypoint = {61.9, 76.8},
                            items = {
                                {
                                    id = 184301,
                                },
                                {
                                    id = 182079,
                                    mount = 1410,
                                },
                            },
                        },
                        {
                            name = "Oily Invertebrate",
                            id = 48859,
                            quest = 61724,
                            waypoint = {61.9, 76.8},
                            items = {
                                {
                                    id = 184300,
                                },
                                {
                                    id = 184155,
                                    quest = 62804,
                                    transmog = true,
                                },
                                {
                                    id = 181270,
                                    pet = 2960,
                                }
                            },
                        },
                        {
                            name = "Gelloh",
                            id = 157309,
                            quest = 61720,
                            waypoint = {61.9, 76.8},
                        },
                        {
                            name = "Corrupted Sediment",
                            id = 48863,
                            quest = 61719,
                            waypoint = {61.9, 76.8},
                            items = {
                                id = 184302,
                            },
                        },
                        {
                            name = "Pulsing Leech",
                            id = 48854,
                            quest = 61718,
                            waypoint = {61.9, 76.8},
                        },
                        {
                            name = "Boneslurp",
                            id = 48860,
                            quest = 61722,
                            waypoint = {61.9, 76.8},
                        },
                        {
                            name = "Burnblister",
                            id = 48862,
                            quest = 61723,
                            waypoint = {61.9, 76.8},
                            items = {
                                id = 184175,
                            },
                        },
                        {
                            name = "Deadly Dapperling",
                            id = 162711,
                            quest = 58868,
                            waypoint = {76.8, 57.0},
                            items = {
                                {
                                    id = 184280,
                                },
                                {
                                    id = 181263,
                                    pet = 2953,
                                },
                            },
                        },
                        {
                            name = "Nerissa Heartless",
                            id = 162690,
                            quest = 58851,
                            waypoint = {66.0, 35.7},
                            items = {
                                {
                                    id = 184179,
                                },
                                {
                                    id = 182084,
                                    mount = 1373,
                                },
                            },
                        },
                        {
                            name = "Necromantic Anomaly",
                            id = 174108,
                            quest = 62369,
                            waypoint = {72.4, 28.6},
                            items = {
                                -- {
                                --     id = 184174,
                                --     item = true,
                                -- },
                                {
                                    id = 181810,
                                    transmog = true,
                                },
                            },
                        },
                        {
                            name = "Bubbleblood",
                            id = 162727,
                            quest = 58870,
                            waypoint = {51.9, 36.4},
                            items = {
                                {
                                    id = 184290,
                                },
                                {
                                    id = 184154,
                                    transmog = true,
                                },
                                {
                                    id = 184476,
                                    toy = true,
                                },
                            },
                        },
                        {
                            name = "Sister Chelicerae",
                            id = 159886,
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
                            name = "Collector Kash",
                            id = 159105,
                            quest = 58005,
                            waypoint = {49.0, 23.4},
                            items = {
                                {
                                    id = 184188,
                                },
                                {
                                    id = 184181,
                                },
                                {
                                    id = 184189,
                                },
                                {
                                    id = 184182,
                                },
                            },
                        },
                        {
                            name = "Devour'us",
                            id = 162669,
                            quest = 58835,
                            waypoint = {44.0, 29.5},
                            items = {
                                {
                                    id = 184178,
                                },
                            },
                        },
                        {
                            name = "Corpsecutter Moroc",
                            id = 157058,
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
                            name = "Gieger",
                            id = 162741,
                            quest = 58872,
                            waypoint = {31.5, 35.3},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 184298,
                                },
                                {
                                    id = 182080,
                                    mount = 1411,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Zargox the Reborn",
                            id = 157125,
                            quest = 59290,
                            waypoint = {28.9, 51.3},
                            items = {
                                {
                                    id = 184285,
                                },
                                {
                                    id = 181804,
                                    transmog = true,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Warbringer Mal'korak",
                            id = 162819,
                            quest = 58889,
                            waypoint = {33.6, 80.4},
                            items = {
                                {
                                    id = 184288,
                                },
                                {
                                    id = 182085,
                                    mount = 1372,
                                },
                            },
                        },
                        {
                            name = "Tahonta",
                            id = 162586,
                            quest = 58783,
                            waypoint = {44.0, 51.1},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 182190,
                                },
                                {
                                    id = 182075,
                                    mount = 1366,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Deepscar",
                            id = 162797,
                            quest = 58878,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 182191,
                                },
                            },
                        },
                        {
                            name = "Gristlebeak",
                            id = 162588,
                            quest = 58837,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 182196,
                                },
                            },
                        },
                        {
                            name = "Indomitable Schmitd",
                            id = 161105,
                            quest = 58332,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 182192,
                                },
                            },
                        },
                        {
                            name = "Nirvaska the Summoner",
                            id = 161857,
                            quest = 58629,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183700,
                                },
                            },
                        },
                        {
                            name = "Pesticide",
                            id = 162767,
                            quest = 58875,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 182205,
                                },
                            },
                        },
                        {
                            name = "Ravenomous",
                            id = 159753,
                            quest = 58004,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 184184,
                                },
                                {
                                    id = 181283,
                                    pet = 2964,
                                },
                            },
                        },
                        {
                            name = "Smorgas the Feaster",
                            id = 162528,
                            quest = 58768,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 184299,
                                },
                                {
                                    id = 181266,
                                    pet = 2956,
                                },
                                {
                                    id = 181265,
                                    pet = 2955,
                                },
                            },
                        },
                        {
                            name = "Taskmaster Xox",
                            id = 160059,
                            quest = 58091,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 184186,
                                },
                                {
                                    id = 184192,
                                },
                                {
                                    id = 184187,
                                },
                            },
                        },
                        {
                            name = "Thread Mistress Leeda",
                            id = 162180,
                            quest = 58678,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 184180,
                                },
                            },
                        },
                    },
                },
                {
                    -- Revendreth
                    id = 1525,
                    covenant = 2,
                    rares = {
                        {
                            hidden = true,
                            name = "Nurgash Muckformed",
                            id = 167526,
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
                            name = "Tollkeeper Varaboss",
                            id = 165253,
                            quest = 59595,
                            waypoint = {66.6, 71.2},
                        },
                        {
                            name = "Harika the Horrid",
                            id = 165290,
                            quest = 59612,
                            waypoint = {45.8, 78.9},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 180461,
                                    mount = 1310,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Worldedge Gorger",
                            id = 160821,
                            quest = 58259,
                            waypoint = {38.6, 72.2},
                            items = {
                                {
                                    id = 182589,
                                    mount = 1391,
                                },
                            },
                        },
                        {
                            name = "Scrivener Lenua",
                            id = 160675,
                            quest = 58213,
                            waypoint = {38.1, 69.0},
                            items = {
                                {
                                    id = 180587,
                                    pet = 2893,
                                },
                            },
                        },
                        {
                            name = "Hopecrusher",
                            id = 166679,
                            quest = 59900,
                            waypoint = {52.0, 51.6},
                            items = {
                                {
                                    id = 180581,
                                    mount = 1298,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Soulstalker Doina",
                            id = 160392,
                            quest = 58130,
                            waypoint = {65.0, 56.8},
                        },
                        {
                            name = "Endlurker",
                            id = 165206,
                            quest = 59582,
                            waypoint = {66.6, 59.2},
                            items = {
                                {
                                    id = 179927,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Famu the Infinite",
                            id = 166521,
                            quest = 59869,
                            waypoint = {62.2, 47.0},
                            items = {
                                {
                                    id = 183739,
                                },
                                {
                                    id = 180582,
                                    mount = 1379,
                                },
                            },
                        },
                        {
                            name = "Forgemaster Madalav",
                            id = 159496,
                            quest = 61618,
                            waypoint = {32.6, 15.4},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 180939,
                                    transmog = true,
                                },
                            },
                        },
                        {
                            name = "Sire Ladinas",
                            id = 160857,
                            quest = 58263,
                            waypoint = {34.0, 55.4},
                            items = {
                                {
                                    id = 180873,
                                    toy = true,
                                },
                            },
                        },
                        {
                            name = "Amalgamation of Filth",
                            id = 166393,
                            quest = 59854,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183729,
                                },
                            },
                        },
                        {
                            name = "Amalgamation of Light",
                            id = 164388,
                            quest = 59584,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 179926,
                                },
                                {
                                    id = 179924,
                                },
                                {
                                    id = 179653,
                                },
                                {
                                    id = 179925,
                                },
                                {
                                    id = 180688,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Amalgamation of Sin",
                            id = 170434,
                            quest = 60836,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183730,
                                },
                            },
                        },
                        {
                            name = "Azgar",
                            id = 166576,
                            quest = 59893,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183731,
                                },
                            },
                        },
                        {
                            name = "Bog Beast",
                            id = 166292,
                            quest = 59823,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180588,
                                    pet = 2896,
                                },
                            },
                        },
                        {
                            name = "Executioner Aatron",
                            id = 166710,
                            quest = 59913,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183737,
                                },
                            },
                        },
                        {
                            name = "Executioner Adrastia",
                            id = 161310,
                            quest = 58441,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180502,
                                },
                            },
                        },
                        {
                            name = "Grand Arcanist Dimitri",
                            id = 167464,
                            quest = 60173,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180503,
                                },
                            },
                        },
                        {
                            name = "Huntmaster Petrus",
                            id = 166993,
                            quest = 60022,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180705,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Innervus",
                            id = 160640,
                            quest = 58210,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183735,
                                },
                            },
                        },
                        {
                            name = "Leeched Soul",
                            id = 165152,
                            quest = 59580,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183736,
                                },
                                {
                                    id = 180585,
                                    pet = 2897,
                                },
                            },
                        },
                        {
                            name = "Lord Mortegore",
                            id = 161891,
                            quest = 58633,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180501,
                                },
                            },
                        },
                        {
                            name = "Manifestation of Wrath",
                            id = 170048,
                            quest = 60729,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180585,
                                    pet = 2897,
                                },
                            },
                        },
                        {
                            name = "Sinstone Hoarder",
                            id = 162481,
                            quest = 62252,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183732,
                                },
                            },
                        },
                        {
                            name = "Stonefist",
                            id = 159503,
                            quest = 62220,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180488,
                                },
                            },
                        },
                        {
                            name = "Tomb Burster",
                            id = 155779,
                            quest = 56877,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180584,
                                    pet = 2891,
                                },
                            },
                        },
                    },
                },
                {
                    -- Bastion
                    id = 1533,
                    covenant = 1,
                    rares = {
                        {
                            hidden = true,
                            name = "Valinor, the Light of Eons",
                            id = 167524,
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
                            },
                        },
                        {
                            name = "Sundancer",
                            id = 170548,
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
                            name = "Wingflayer the Cruel",
                            id = 167078,
                            quest = 60314,
                            waypoint = {40.7, 52.9},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 182749,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Dark Watcher",
                            id = 170623,
                            quest = 60883,
                            waypoint = {27.7, 30.0},
                            items = {
                                {
                                    id = 184297,
                                },
                            },
                        },
                        {
                            name = "Orstus & Sotiros",
                            id = 156339,
                            quest = 61634,
                            covenantRequired = true,
                            waypoint = {22.6, 22.9},
                            items = {
                                {
                                    id = 184365,
                                },
                                {
                                    id = 184401,
                                    -- pet = true, -- todo
                                },
                                {
                                    id = 184397,
                                    -- pet = true, -- todo
                                },
                            },
                        },
                        {
                            name = "Ascended Council",
                            id = 170899,
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
                            name = "Enforcer Aegeon",
                            id = 171009,
                            quest = 60998,
                            waypoint = {50.8, 19.6},
                            items = {
                                {
                                    id = 184404,
                                    toy = true,
                                },
                            },
                        },
                        {
                            name = "Unstable Memory",
                            id = 171008,
                            quest = 60997,
                            waypoint = {43.4, 25.2},
                            items = {
                                {
                                    id = 184413,
                                    toy = true,
                                },
                            },
                        },
                        {
                            name = "Aspirant Eolis",
                            id = 171211,
                            quest = 61083,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183607,
                                },
                            },
                        },
                        {
                            name = "Baedos",
                            id = 160629,
                            quest = {58648, 62192},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                        },
                        {
                            name = "Basilofos",
                            id = 170659,
                            quest = {60897, 62158},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            -- items = {
                            --     {
                            --         id = 182655,
                            --         toy = true,
                            --     },
                            -- },
                        },
                        {
                            name = "Beasts of Bastion",
                            id = 161527,
                            quest = {60570, 60571, 60569, 58526},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 179485,
                                },
                                {
                                    id = 179486,
                                },
                                {
                                    id = 179487,
                                },
                                {
                                    id = 179488,
                                },
                            },
                        },
                        {
                            name = "Bookkeeper Mnemis",
                            id = 171189,
                            quest = 59022,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 182682,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Cloudfeather Guardian",
                            id = 170932,
                            quest = {60978, 62191},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180812,
                                    pet = 2925,
                                },
                            },
                        },
                        {
                            name = "Collector Astorestes",
                            id = 171014,
                            quest = 61002,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183608,
                                },
                            },
                        },
                        {
                            name = "Corrupted Clawguard",
                            id = 171010,
                            quest = 60999,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                        },
                        {
                            name = "Collector Astorestes",
                            id = 171014,
                            quest = 61002,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183608,
                                },
                            },
                        },
                        {
                            name = "Demi the Relic Hoarder",
                            id = 171011,
                            quest = {61069, 61000},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183606,
                                },
                                {
                                    id = 183608,
                                },
                                {
                                    id = 183613,
                                },
                                {
                                    id = 183611,
                                },
                                {
                                    id = 183609,
                                },
                                {
                                    id = 183607,
                                },
                            },
                        },
                        {
                            name = "Dionae",
                            id = 163460,
                            quest = 62650,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180856,
                                    pet = 2932,
                                },
                            },
                        },
                        {
                            name = "Echo of Aella <Hand of Courage>",
                            id = 171255,
                            quest = {61082, 61091, 62251},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180062,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Fallen Acolyte Erisne",
                            id = 160721,
                            quest = 58222,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180444,
                                },
                            },
                        },
                        {
                            name = "Herculon",
                            id = 158659,
                            quest = {57705, 57708},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            -- items = {
                            --     {
                            --         id = 182759,
                            --     },
                            -- },
                        },
                        {
                            name = "Nikara Blackheart",
                            id = 160882,
                            quest = 58319,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183608,
                                },
                            },
                        },
                        -- {
                        --     name = "Reekmonger",
                        --     id = 171327,
                        --     hidden = true,
                        --     waypoint = {99.9, 99.9},
                        -- },
                        {
                            name = "Selena the Reborn",
                            id = 160985,
                            quest = 58320,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183608,
                                },
                            },
                        },
                        {
                            name = "Swelling Tear",
                            id = 171012,
                            quest = {61001, 61046, 61047},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183605,
                                },
                                {
                                    id = 180869,
                                    pet = 2940,
                                },
                            },
                        },
                    },
                },
                {
                    -- Ardenweald
                    id = 1565,
                    covenant = 3,
                    rares = {
                        {
                            -- hidden = true,
                            name = "Oranomonos the Everbranching",
                            id = 167527,
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
                            name = "Humon'gozz",
                            id = 164112,
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
                            name = "Valfir the Unrelenting",
                            id = 168647,
                            quest = 61632,
                            waypoint = {30.6, 55.0},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 180154,
                                },
                                {
                                    id = 180730,
                                    mount = 1393,
                                    covenantOnly = true,
                                },
                                {
                                    id = 182176,
                                    item = true,
                                    quest = 62431,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Gormtamer Tizo",
                            id = 164107,
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
                            name = "Night Mare",
                            id = 168135,
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
                            name = "Hunter Vivian",
                            id = 160448,
                            quest = 59221,
                            waypoint = {67.1, 24.6},
                            items = {
                                {
                                    id = 179596,
                                    transmog = true,
                                },
                                {
                                    id = 183091,
                                    item = true,
                                    quest = 62246,
                                },
                            },
                        },
                        {
                            name = "Deifir the Untamed",
                            id = 164238,
                            quest = {59201, 62271},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180631,
                                    pet = 2920,
                                },
                            },
                        },
                        {
                            name = "Dustbrawl",
                            id = 163229,
                            quest = 58987,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                        },
                        {
                            name = "Egg-Tender Leh'go",
                            id = 167851,
                            quest = 60266,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 179539,
                                },
                            },
                        },
                        {
                            name = "Faeflayer",
                            id = 171688,
                            quest = 61184,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180144,
                                },
                            },
                        },
                        {
                            name = "Gormbore",
                            id = 163370,
                            quest = 59006,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 183196,
                                    pet = 3035,
                                },
                            },
                        },
                        {
                            name = "Macabre",
                            id = 164093,
                            quest = 59140,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180644,
                                    pet = 2907,
                                },
                            },
                        },
                        {
                            name = "Mymaen",
                            id = 165053,
                            quest = 59431,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 179502,
                                },
                            },
                        },
                        {
                            name = "Mystic Rainbowhorn",
                            id = 164547,
                            quest = 59235,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 179586,
                                },
                                {
                                    id = 182179,
                                    item = true,
                                    quest = 62434,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "Old Ardeite",
                            id = 164391,
                            quest = {59208, 62270},
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180643,
                                    pet = 2908,
                                },
                            },
                        },
                        {
                            name = "Rootwrithe",
                            id = 167726,
                            quest = 60273,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 179603,
                                },
                            },
                        },
                        {
                            name = "Rotbriar Boggart",
                            id = 167724,
                            quest = 60258,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 175729,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Soultwister Cero",
                            id = 171451,
                            quest = 61177,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 180164,
                                },
                            },
                        },
                        {
                            name = "Skuld Vit",
                            id = 164415,
                            quest = 59220,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            covenantRequired = true,
                            items = {
                                {
                                    id = 180146,
                                },
                                {
                                    id = 182183,
                                    item = true,
                                    quest = 62439,
                                    covenantOnly = true,
                                },
                            },
                        },
                        {
                            name = "The Slumbering Emperor",
                            id = 167721,
                            quest = 60290,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 175711,
                                    item = true,
                                },
                            },
                        },
                        {
                            name = "Wrigglemortis",
                            id = 164147,
                            quest = 59170,
                            hidden = true,
                            waypoint = {99.9, 99.9},
                            items = {
                                {
                                    id = 181396,
                                },
                            },
                        },
                    },
                },
            },
            notes = {
                "This is very much a work-in-progress! For the list of issues please go to |cff0099ffhttps://github.com/RavenousAddons/ravFor/issues|r and message |cff63ad76WaldenPond#0001|r on Discord for feedback or help!",
                "I'm also very much interested in getting the UX of this Addon correct and steering players in the direction of catching up, gearing up, and exceeding past our opponents!",
                "Still to come:\n- tracking when certain world quests/world bosses are available\n- some rares still missing coordinates\n- tabs per expansion and per zone\n- your brilliant idea? Get in touch!",
            },
        },
        ["Battle for Azeroth"] = {
            zones = {
                {
                    -- Mechagon
                    id = 1462,
                    color = "d8d3cc",
                    icon = "2620862",
                    rares = {
                        {
                            name = "Arachnoid Harvester",
                            id = 151934,
                            quest = 55512,
                            waypoint = {51.6, 41.6},
                            items = {
                                {
                                    id = 168823,
                                    mount = 1229,
                                },
                            },
                        },
                        {
                            name = "Rustfeather",
                            id = 152182,
                            quest = 55811,
                            waypoint = {63.8, 78.0},
                            items = {
                                {
                                    id = 168370,
                                    mount = 1248,
                                },
                            },
                        },
                    },
                },
                {
                    -- Nazjatar
                    id = 1355,
                    color = "4db3ea",
                    icon = "3012068",
                    currency = 1721,
                    rares = {
                        {
                            name = "Soundless",
                            id = 152290,
                            quest = 56298,
                            waypoint = {57.6, 52.2},
                            items = {
                                {
                                    id = 169163,
                                    mount = 1257,
                                },
                            },
                        },
                    },
                },
            },
        },
    },
    currencies = {
        {
            id = 1792, -- Honor
            color = "f5c87a",
        },
        {
            id = 1602, -- Conquest
            color = "f5c87a",
        },
        {
            id = 1721, -- Prismatic Manapearl
            color = "4db3ea",
        },
        {
            id = 1813, -- Anima
            color = "95c3e1",
        },
        {
            id = 1828, -- Soul Ash
            color = "b0ccd8",
        },
        {
            id = 1767, -- Stygia
            color = "e5cc80",
        },
    },
    covenants = {
        -- Kyrian
        [1] = {
            color = "68ccef",
            icon = 3257748,
            phrase = "Home of the %s",
        },
        -- Venthyr
        [2] = {
            color = "ff4040",
            icon = 3257751,
            phrase = "Court of the %s",
        },
        -- Night Fae
        [3] = {
            color = "8b55d7",
            icon = 3257750,
            phrase = "Forest of the %s",
        },
        -- Necrolord
        [4] = {
            color = "40bf40",
            icon = 3257749,
            phrase = "Citadel of the %s",
        },
    },
    renownLevels = {
        {
            level = 6,
            year = 2020,
            month = 12,
            day = 1,
        },
        {
            level = 9,
            day = 8,
        },
        {
            level = 12,
            day = 15,
        },
        {
            level = 15,
            day = 22,
        },
        {
            level = 18,
            day = 29,
        },
        {
            level = 21,
            year = 2021,
            month = 1,
            day = 5,
        },
        {
            level = 24,
            day = 12,
        },
        {
            level = 26,
            day = 19,
        },
        {
            level = 28,
            day = 26,
        },
        {
            level = 30,
            month = 2,
            day = 2,
        },
        {
            level = 32,
            day = 9,
        },
        {
            level = 34,
            day = 16,
        },
        {
            level = 36,
            day = 23,
        },
        {
            level = 38,
            month = 3,
            day = 2,
        },
        {
            level = 40,
            day = 9,
        },
    },
    gorgedShadehoundDates = {

    },
}
