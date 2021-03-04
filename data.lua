local ADDON_NAME, ns = ...

ns.defaults = {
    locked = false,
    macro = true,
    minimapButton = true,
    showReputation = true,
    showOwned = true,
    showCannotUse = true,
    showNoDrops = true,
    showGear = true,
    showTransmog = true,
    showMounts = true,
    showPets = true,
    showToys = true,
    scale = 1,
    windowPosition = "CENTER",
    windowX = 0,
    windowY = 0,
    windowWidth = 420,
    windowHeight = 360,
    minimapPosition = 0,
}

ns.data = {
    notes = {
        "Thanks for installing Ravenous For Shadowlands! Check your General Macros for a macro called |cffffc478Ravenous For|r or type |cffffc478/ravfor|r to open the main window. I love making Addons that people find useful and improves their enjoyment of the game, more than anything else. If you'd like to get involved in any capacity, please reach out!",
        "This is very much a work-in-progress! For the list of issues please go to |cff0099ffhttps://github.com/RavenousAddons/ravFor/issues|r and message |cff63ad76WaldenPond#0001|r on Discord for feedback or help!",
        "Still to come:\n\n- Correctly tracking all different drop types (particularly: items, armor, weapons)\n- Investigating Mythic+ and Rated PVP data that can be exposed by the API\n- Your brilliant idea? Please get in touch!",
    },
    expansions = {
        ["Shadowlands"] = {
            icon = 3642306,
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
                            name = "Hunt: Shadehounds",
                            id = 174827,
                            -- quest = ?????,
                            biweekly = true,
                            waypoint = 53607860,
                            items = {
                                {
                                    id = 184167,
                                    mount = 1304,
                                },
                            },
                        },
                        {
                            hidden = true,
                            name = "Hunt: Death Elementals",
                            id = 172958, -- 172958, 122960, 172961, 172962
                            quest = 62593,
                            biweekly = true,
                            waypoint = 53607860,
                        },
                        {
                            hidden = true,
                            name = "Hunt: Winged Soul Eaters",
                            id = 999999,
                            -- quest = ?????,
                            biweekly = true,
                            waypoint = 53607860,
                        },
                        {
                            hidden = true,
                            name = "Hunt: Soul Eaters",
                            id = 999999,
                            -- quest = ?????,
                            biweekly = true,
                            waypoint = 53607860,
                        },
                        {
                            name = "Borr-Geth",
                            id = 157833,
                            quest = 57469,
                            waypoint = 39014119,
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
                            waypoint = 19194608,
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
                            waypoint = 16945102,
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
                            waypoint = 19324172,
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
                            waypoint = 23692139,
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
                            waypoint = 25923116,
                            reputation = 80,
                        },
                        {
                            name = "Conjured Death",
                            id = 171317,
                            quest = 61106,
                            waypoint = 27731305,
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
                            waypoint = 60964805,
                            reputation = 100,
                        },
                        {
                            name = "Darklord Taraxis",
                            id = 158025,
                            quest = 62282,
                            waypoint = 49128175,
                            reputation = 80,
                        },
                        {
                            name = "Dolos <Death's Knife>",
                            id = 170711,
                            quest = 60909,
                            waypoint = 28086058,
                            reputation = 100,
                        },
                        {
                            name = "Eketra <The Impaler>",
                            id = 170774,
                            quest = 60915,
                            waypoint = 23765341,
                            reputation = 100,
                        },
                        {
                            name = "Ekphoras, Herald of Grief",
                            id = 169827,
                            quest = 60666,
                            waypoint = 42342108,
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
                            waypoint = 20586935,
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
                            waypoint = 30775000,
                            reputation = 100,
                        },
                        {
                            name = "Nascent Devourer",
                            id = 158278,
                            quest = 57573,
                            waypoint = 45507376,
                            reputation = 80,
                        },
                        {
                            name = "Obolos <Prime Adjutant>",
                            id = 164064,
                            quest = 60667,
                            waypoint = 48801830,
                            reputation = 80,
                        },
                        {
                            name = "Shadeweaver Zeris",
                            id = 170634,
                            quest = 60884,
                            waypoint = 32946646,
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
                            waypoint = 35974156,
                            reputation = 80,
                        },
                        {
                            name = "Talaporas, Herald of Pain",
                            id = 170302,
                            quest = 60789,
                            waypoint = 28701204,
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
                            waypoint = 27397152,
                            reputation = 100,
                        },
                        {
                            name = "Yero the Skittish",
                            id = 172862,
                            quest = 61568,
                            waypoint = 37446212,
                            reputation = 80,
                        },
                    },
                },
                {
                    -- Maldraxxus
                    id = 1536,
                    covenant = 4,
                    faction = 2410,
                    rares = {
                        {
                            name = "Mortanis",
                            id = 173104,
                            quest = 61816,
                            worldquest = true,
                            waypoint = 32306700,
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
                                    guaranteed = true,
                                    class = "Monk",
                                    specialization = "Windwalker",
                                },
                                {
                                    id = 183386,
                                    guaranteed = true,
                                    class = "Warrior",
                                    specialization = "Fury",
                                },
                                {
                                    id = 183341,
                                    guaranteed = true,
                                    class = "Rogue",
                                    specialization = "Outlaw",
                                },
                            },
                        },
                        {
                            name = "Theater of Pain Rares",
                            id = 162853,
                            quest = 62786,
                            waypoint = 50354728,
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
                            waypoint = 50354728,
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
                            waypoint = 62107580,
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
                            waypoint = 58197421,
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
                            waypoint = 58197421,
                            items = {
                                {
                                    id = 184301,
                                },
                                {
                                    id = 182079,
                                    mount = 1410,
                                },
                            },
                            notes = {
                                "To Summon: |cffff6666Red|r = |cff6666ffBlue|r > |cffffff66Yellow|r",
                            },
                        },
                        {
                            name = "Oily Invertebrate",
                            id = 48859,
                            quest = 61724,
                            waypoint = 58197421,
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
                                },
                            },
                            notes = {
                                "To Summon: 10 |cffff6666Red|r 10 |cff6666ffBlue|r 10 |cffffff66Yellow|r",
                            },
                        },
                        {
                            name = "Gelloh",
                            id = 157307,
                            quest = 61721,
                            waypoint = 58197421,
                            items = {
                                {
                                    id = 182287,
                                },
                            },
                            notes = {
                                "To Summon: 15+ |cffffff66Yellow|r",
                            },
                        },
                        {
                            name = "Corrupted Sediment",
                            id = 48863,
                            quest = 61719,
                            waypoint = 58197421,
                            items = {
                                {
                                    id = 184302,
                                },
                            },
                            notes = {
                                "To Summon: 15+ |cff6666ffBlue|r",
                            },
                        },
                        {
                            name = "Burnblister",
                            id = 48862,
                            quest = 61723,
                            waypoint = 58197421,
                            items = {
                                {
                                    id = 184175,
                                },
                            },
                            notes = {
                                "To Summon: |cffff6666Red|r = |cffffff66Yellow|r > |cff6666ffBlue|r",
                            },
                        },
                        {
                            name = "Pulsing Leech",
                            id = 48854,
                            quest = 61718,
                            waypoint = 58197421,
                            notes = {
                                "To Summon: 15+ |cffff6666Red|r",
                            },
                        },
                        {
                            name = "Boneslurp",
                            id = 48860,
                            quest = 61722,
                            waypoint = 58197421,
                            notes = {
                                "To Summon: |cff6666ffBlue|r = |cffffff66Yellow|r > |cffff6666Red|r",
                            },
                        },
                        {
                            name = "Deadly Dapperling",
                            id = 162711,
                            quest = 58868,
                            waypoint = 76835707,
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
                            waypoint = 66023532,
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
                            waypoint = 72872891,
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
                            waypoint = 52663542,
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
                            waypoint = 55502361,
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
                            waypoint = 49012351,
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
                            waypoint = 45052842,
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
                            waypoint = 26392633,
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
                            waypoint = 31603540,
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
                            waypoint = 28965138,
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
                            waypoint = 33718016,
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
                            waypoint = 44215132,
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
                            waypoint = 46734550,
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
                            waypoint = 57795155,
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
                            waypoint = 38794333,
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
                            waypoint = 50346328,
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
                            waypoint = 53726132,
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
                            waypoint = 53841877,
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
                            waypoint = 42465345,
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
                            waypoint = 50562011,
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
                            waypoint = 24184297,
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
                    faction = {2413, 2439},
                    rares = {
                        {
                            name = "Nurgash Muckformed",
                            id = 167526,
                            quest = 61814,
                            worldquest = true,
                            waypoint = 27601460,
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
                                    guaranteed = true,
                                    class = "Death Knight",
                                    specialization = "Unholy",
                                },
                                {
                                    id = 183215,
                                    guaranteed = true,
                                    class = "Demon Hunter",
                                    specialization = "Havoc",
                                },
                                {
                                    id = 183376,
                                    guaranteed = true,
                                    class = "Warlock",
                                    specialization = "Destruction",
                                },
                            },
                        },
                        {
                            name = "Tollkeeper Varaboss",
                            id = 165253,
                            quest = 59595,
                            waypoint = 66507080,
                        },
                        {
                            name = "Harika the Horrid",
                            id = 165290,
                            quest = 59612,
                            waypoint = 45847919,
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
                            waypoint = 38607200,
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
                            waypoint = 38316914,
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
                            waypoint = 51985179,
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
                            waypoint = 78934975,
                        },
                        {
                            name = "Endlurker",
                            id = 165206,
                            quest = 59582,
                            waypoint = 66555946,
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
                            waypoint = 62484716,
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
                            waypoint = 32641545,
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
                            waypoint = 34045555,
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
                            waypoint = 53247300,
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
                            waypoint = 25304850,
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
                                {
                                    id = 180586,
                                    pet = 2892,
                                },
                            },
                        },
                        {
                            name = "Amalgamation of Sin",
                            id = 170434,
                            quest = 60836,
                            waypoint = 65782914,
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
                            waypoint = 35817052,
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
                            waypoint = 35003230,
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
                            waypoint = 37084742,
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
                            waypoint = 43055183,
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
                            waypoint = 20485298,
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
                            waypoint = 61717949,
                            items = {
                                {
                                    id = 180705,
                                    item = true,
                                    class = "Hunter",
                                },
                            },
                        },
                        {
                            name = "Innervus",
                            id = 160640,
                            quest = 58210,
                            waypoint = 21803590,
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
                            waypoint = 67978179,
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
                            waypoint = 75976161,
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
                            waypoint = 49003490,
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
                            waypoint = 67443048,
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
                            waypoint = 31312324,
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
                            waypoint = 43007910,
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
                    faction = 2407,
                    rares = {
                        {
                            name = "Valinor <The Light of Eons>",
                            id = 167524,
                            quest = 61813,
                            worldquest = true,
                            waypoint = 26602280,
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
                                    guaranteed = true,
                                    class = "Paladin",
                                    specialization = "Retribution",
                                },
                                {
                                    id = 183325,
                                    guaranteed = true,
                                    class = "Priest",
                                    specialization = "Holy",
                                },
                                {
                                    id = 183353,
                                    guaranteed = true,
                                    class = "Shaman",
                                    specialization = "Elemental",
                                },
                            },
                        },
                        {
                            name = "Sundancer",
                            id = 170548,
                            quest = 60862,
                            waypoint = 61409050,
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
                            waypoint = 40635306,
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
                            waypoint = 27823014,
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
                            waypoint = 22432285,
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
                            waypoint = 53498868,
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
                            waypoint = 51151953,
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
                            waypoint = 43482524,
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
                            waypoint = 32592336,
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
                            waypoint = 51344080,
                        },
                        {
                            name = "Basilofos",
                            id = 170659,
                            quest = {60897, 62158},
                            waypoint = 48985031,
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
                            waypoint = 55358024,
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
                            waypoint = 55826249,
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
                            waypoint = 50435804,
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
                            waypoint = 66004367,
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
                            waypoint = 56904778,
                        },
                        {
                            name = "Demi the Relic Hoarder",
                            id = 171011,
                            quest = {61069, 61000},
                            waypoint = 37004180,
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
                            waypoint = 41354887,
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
                            waypoint = 45656550,
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
                            waypoint = 60427305,
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
                            waypoint = 42908265,
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
                            waypoint = 51456859,
                            items = {
                                {
                                    id = 183608,
                                },
                            },
                        },
                        {
                            name = "Reekmonger",
                            id = 171327,
                            waypoint = 30365517,
                        },
                        {
                            name = "Selena the Reborn",
                            id = 160985,
                            quest = 58320,
                            waypoint = 61295090,
                            items = {
                                {
                                    id = 183608,
                                },
                            },
                        },
                        {
                            hidden = true,
                            name = "Swelling Tear",
                            id = 171012,
                            quest = {61001, 61046, 61047},
                            waypoint = 39604499,
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
                    faction = {2465, 2464},
                    rares = {
                        {
                            name = "Oranomonos the Everbranching",
                            id = 167527,
                            quest = 61815,
                            worldquest = true,
                            waypoint = 20606360,
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
                                    guaranteed = true,
                                    class = "Druid",
                                    specialization = "Restoration",
                                },
                                {
                                    id = 183261,
                                    guaranteed = true,
                                    class = "Hunter",
                                    specialization = "Marksman",
                                },
                                {
                                    id = 183274,
                                    guaranteed = true,
                                    class = "Mage",
                                    specialization = "Fire",
                                },
                            },
                        },
                        {
                            name = "Humon'gozz",
                            id = 164112,
                            quest = 59157,
                            waypoint = 32423026,
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
                            waypoint = 30115536,
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
                            waypoint = 27885248,
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
                            covenantOnly = true,
                            waypoint = 57874983,
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
                            name = "Hunter Vivanna",
                            id = 160448,
                            quest = 59221,
                            waypoint = 67465147,
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
                            waypoint = 47522845,
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
                            waypoint = 48397717,
                        },
                        {
                            name = "Egg-Tender Leh'go",
                            id = 167851,
                            quest = 60266,
                            waypoint = 57862955,
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
                            waypoint = 68612765,
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
                            waypoint = 54067601,
                            items = {
                                {
                                    id = 183196,
                                    pet = 3035,
                                },
                            },
                        },
                        {
                            hidden = true,
                            name = "Macabre",
                            id = 164093,
                            quest = 59140,
                            waypoint = 32664480,
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
                            waypoint = 62102470,
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
                            waypoint = 65702809,
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
                            waypoint = 51105740,
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
                            waypoint = 65104430,
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
                            waypoint = 65702430,
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
                            waypoint = 72425175,
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
                            waypoint = 37675917,
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
                            waypoint = 59304660,
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
                            waypoint = 58306180,
                            items = {
                                {
                                    id = 181396,
                                },
                            },
                        },
                    },
                },
            },
        },
        ["Battle for Azeroth"] = {
            icon = 237383,
            zones = {
                {
                    -- Mechagon
                    id = 1462,
                    color = "dbd9a9",
                    icon = "2915728",
                    rares = {
                        {
                            name = "Arachnoid Harvester",
                            id = 151934,
                            quest = 55512,
                            waypoint = 51604160,
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
                            waypoint = 65637850,
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
                            waypoint = 57605220,
                            items = {
                                {
                                    id = 169163,
                                    mount = 1257,
                                },
                            },
                        },
                    },
                },
                {
                    -- Uldum
                    id = 1527,
                    color = "f8f1bd",
                    icon = "409550",
                    rares = {
                        {
                            name = "Corpse Eater",
                            id = 162147,
                            quest = 58696,
                            assault = "AQR",
                            waypoint = 30854971,
                            items = {
                                {
                                    id = 174769,
                                    mount = 1319,
                                },
                            },
                        },
                        {
                            name = "Rotfeaster",
                            id = 157146,
                            quest = 57273,
                            assault = "AMA",
                            waypoint = 68593204,
                            items = {
                                {
                                    id = 174753,
                                    mount = 1317,
                                },
                            },
                        },
                        {
                            name = "Ishak of the Four Winds",
                            id = 157134,
                            quest = 57259,
                            waypoint = 73908353,
                            items = {
                                {
                                    id = 174641,
                                    mount = 1314,
                                },
                            },
                        },
                        {
                            name = "Springfur Alpaca",
                            id = 162765,
                            quest = 58879,
                            waypoint = {15006200, 24000900, 27004800, 30002900, 39000800, 41007000, 47004800, 52001900, 55006900, 62705340, 63011446, 70003900, 76636813},
                            items = {
                                {
                                    id = 174859,
                                    mount = 1329,
                                },
                            },
                        },
                    },
                },
                {
                    -- Vol'dun
                    id = 1195,
                    color = "d28b68",
                    icon = "2125384",
                    rares = {
                        {
                            name = "Elusive Alpaca",
                            id = 162681,
                            waypoint = {26405250, 29006600, 31106730, 42006000, 43006900, 51108590, 52508900, 54008200, 54605320, 55007300},
                            items = {
                                {
                                    id = 174860,
                                    mount = 1324,
                                },
                            },
                        },
                    },
                },
                {
                    -- Vale of Eternal Blossoms
                    id = 1530,
                    color = "b8dab6",
                    icon = "618798",
                    rares = {
                        {
                            name = "Anh-De the Loyal",
                            id = 157466,
                            quest = 57363,
                            waypoint = 34156805,
                            items = {
                                {
                                    id = 174840,
                                    mount = 1328,
                                },
                            },
                        },
                        {
                            name = "Ha-Li",
                            id = 157153,
                            quest = 57344,
                            waypoint = {37323630, 33973378, 29053930, 31524387, 37313632, 37323630},
                            items = {
                                {
                                    id = 173887,
                                    mount = 1297,
                                },
                            },
                        },
                        {
                            name = "Houndlord Ren",
                            id = 157160,
                            quest = 57345,
                            assaulut = "MOG",
                            waypoint = {13132578, 11833049, 08953570},
                            items = {
                                {
                                    id = 174841,
                                    mount = 1327,
                                },
                            },
                        },
                        {
                            name = "Rei Lun",
                            id = 157162,
                            quest = 57346,
                            assault = "MOG",
                            waypoint = 21901232,
                            items = {
                                {
                                    id = 174649,
                                    mount = 1313,
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
            id = 1813, -- Reservoir Anima
            color = "95c3e1",
        },
        {
            id = 1810, -- Redeemed Souls
            color = "f5dcd0",
        },
        {
            id = 1828, -- Soul Ash
            color = "b0ccd8",
        },
        {
            id = 1767, -- Stygia
            color = "e5cc80",
        },
        {
            id = 1885, -- Grateful Offerings
            color = "96dc93",
        }
    },
    reputationColors = {
        "cc2222",
        "ff0000",
        "ee6622",
        "ffff00",
        "00ff00",
        "00ff88",
        "00ffcc",
        "00ffff",
        "00ffff",
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
    animaValuesBySpellID = {
        [347555] = 3,
        [345706] = 5,
        [336327] = 35,
        [336456] = 250,
    }
}
