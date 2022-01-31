local ADDON_NAME, ns = ...

ns.defaults = {
    locked = false,
    minimapButton = true,
    macro = true,
    showOwned = true,
    showCannotUse = true,
    showNoDrops = true,
    allowSharing = true,
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
        "Thanks for installing Ravenous For Shadowlands! Check your General Macros for a macro called |cffffc478Ravenous For|r, use the Minimap button, or type |cffffc478/ravfor|r to open the main window.",
        "Clicking on Rares' names will place a Map Pin on their location and print a shareable link to the Map Pin in your chat. If you're the leader of your group, you can Alt/Ctrl/Shift+Click on their names to mark the them for yourself and everyone else in your group who also has the Addon.",
        "Most notable Rares, Reputations, and Currencies are filled-out for Shadowlands, and the plan is to continue to update the Addon as the expansion progresses. As preparation/testing I've also included a number of notable Mount drops from Battle for Azeroth Rares, but there are no major plans to flesh this out as I've done for Shadowlands.",
        "There are a handful of other things to mouseover and click, and let me know how I can improve or add to these existing features!",
        "This is very much a work-in-progress! For the list of issues please go to |cff0099ffhttps://github.com/RavenousAddons/ravFor/issues|r and message |cff63ad76WaldenPond#0001|r on Discord for feedback or help!",
        "Still in-progress:\n\n- Correctly checking whether or not armor/weapons are usable by the player\n- More bug-fixes, features, improvements\n- Your brilliant idea? Please get in touch!",
    },
    expansions = {
        {
            name = "Shadowlands",
            icon = 3642306,
            zones = {
                {
                    -- Korthia
                    id = 1961,
                    color = "e5cc80",
                    icon = 3052062,
                    currency = 1931,
                    faction = {2470, 2472},
                    rares = {
                        {id=177336,name="Zelnithop",waypoint=30305480,items={{id=186542,pet=3136,},},quest=64442,},
                        {id=177903,name="Dominated Protector",waypoint=51802080,quest=63830,},
                        {id=179108,name="Kroke the Tormented",waypoint=59203580,items={{id=187250,},{id=187248,},},quest=64428,},
                        {id=179472,name="Konthrogz the Obliterator",waypoint=10008000,items={{id=187183,mount=1514,},},quest=64246,},
                        {id=179608,name="Screaming Shade",waypoint=44604240,quest=64263,},
                        {id=179684,name="Malbog",waypoint=44202920,items={{id=186645,mount=1506,},},notes={"Talk to Caretaker Kah-Kay in town, then follow footprints"},quest=64233,},
                        {id=179760,name="Towering Exterminator",waypoint=12008000,items={{id=187241,},{id=187242,},{id=187035,},},quest=64245,},
                        {id=179768,name="Consumption",waypoint=51154165,items={{id=187245,},{id=187246,},{id=187247,},},notes={"Starts as a regular mob, eats Drab Gromit until it becomes a rare, and then a rare-elite. Loot gets better as it gets stronger, so wait."},quest=64243,},
                        {id=179802,name="Yarxhov the Pillager",waypoint=39405240,items={{id=187103,quest=63917,},},quest=64257,},
                        {id=179859,name="Xyraxz the Unknowable",waypoint=44903550,items={{id=186538,pet=3140,},{id=187104,quest=63918,},},quest=64278,},
                        {id=179911,name="Silent Soulstalker",waypoint=57607040,quest=64284,},
                        {id=179912,name="Maelie the Wanderer",waypoint={30005560,33103865,35804650,35856225,38403140,39703490,41103980,41302750,42806040,43203130,49304170,50302290,59801510,61304040,62404970,},items={{id=186643,mount=1511,}},notes={"Tinybell asks you to find Maelie the Wanderer, who spawns in a different place each day. Find her each day, use Reassure on her, and get a mount from Tinybell"},quest={64292,64298,},},
                        {id=179913,name="Deadsoul Hatcher",waypoint=59355220,items={{id=187174,toy=true,},},quest=64285,},
                        {id=179914,name="Observer Yorik",waypoint=50307590,items={{id=187420,toy=true,},},quest=64440,},
                        {id=179931,name="Relic Breaker Krelva",waypoint=22604140,quest=64291,},
                        {id=179985,name="Stygian Stonecrusher",waypoint=46507950,items={{id=186479,covenant=2},{id=187283,quest=64530,},{id=187428,quest=64553,}},quest=64313,},
                        {id=180014,name="Escaped Wilderling",waypoint=33103930,items={{id=186492,mount=1487,covenant=3}},quest=64320,},
                        {id=180032,name="Wild Worldcracker",waypoint=47003560,items={{id=187176,toy=true,},{id=186483,mount=1493,covenant=1},{id=187426,quest=64552,}},quest=64338,},
                        {id=180042,name="Fleshwing",waypoint=59954370,items={{id=186489,mount=1449,covenant=4,},{id=187181,},{id=187424,quest=64551,}},quest=64349,},
                        {id=180160,name="Reliwik the Defiant",waypoint=56256615,items={{id=186652,mount=1509,},},quest=64455,},
                        {id=180162,name="Ve'rayn",waypoint=14008000,items={{id=187264,quest=64513,},},quest=64457,},
                        {id=180246,name="Carriage Crusher",waypoint=58201775,quest=64258,},
                    },
                },
                {
                    -- The Maw
                    id = 1543,
                    color = "e5cc80",
                    icon = 3743739,
                    currency = 1767,
                    faction = 2432,
                    rares = {
                        {name="Borr-Geth",id=157833,quest=57469,waypoint=39014119,items={{id=184312,toy=true}}},
                        {name="Eternas the Tormentor",id=154330,quest=57509,waypoint=19194608,items={{id=183407,pet=3037}}},
                        {name="Morguliax <Lord of Decapitation>",id=162849,quest=60987,waypoint=16945102,items={{id=184292,toy=true}}},
                        {name="Apholeias, Herald of Loss",id=170301,quest=60788,waypoint=19324172,items={{id=184106},{id=182327}}},
                        {name="Orophea",id=172577,quest=61519,waypoint=23692139,items={{id=181794,toy=true}}},
                        {name="Adjutant Dekaris",id=157964,quest=57482,waypoint=25923116},
                        {name="Conjured Death",id=171317,quest=61106,waypoint=27731305},
                        {name="Darithis the Bleak",id=160770,quest=62281,waypoint=60964805},
                        {name="Darklord Taraxis",id=158025,quest=62282,waypoint=49128175},
                        {name="Dolos <Death's Knife>",id=170711,quest=60909,waypoint=28086058},
                        {name="Eketra <The Impaler>",id=170774,quest=60915,waypoint=23765341},
                        {name="Ekphoras, Herald of Grief",id=169827,quest=60666,waypoint=42342108,items={{id=184105},{id=182328}}},
                        {name="Exos, Herald of Domination",id=170303,quest=62260,waypoint=20586935,items={{id=184108},{id=183066,quest=63160},{id=183067,quest=63161},{id=183068,quest=63162}}},
                        {name="Ikras the Devourer",id=175012,quest=62788,waypoint=30775000},
                        {name="Nascent Devourer",id=158278,quest=57573,waypoint=45507376},
                        {name="Obolos <Prime Adjutant>",id=164064,quest=60667,waypoint=48801830},
                        {name="Shadeweaver Zeris",id=170634,quest=60884,waypoint=32946646,items={{id=183066,quest=63160},{id=183067,quest=63161},{id=183068,quest=63162}}},
                        {name="Soulforger Rhovus",id=166398,quest=60834,waypoint=35974156},
                        {name="Talaporas, Herald of Pain",id=170302,quest=60789,waypoint=28701204,items={{id=182326}}},
                        {name="Thanassos <Death's Voice>",id=170731,quest=60914,waypoint=27397152},
                        {name="Yero the Skittish",id=172862,quest=61568,waypoint=37446212},
                    },
                },
                {
                    -- Maldraxxus
                    id = 1536,
                    covenant = 4,
                    faction = 2410,
                    rares = {
                        {name="Mortanis",id=173104,quest=61816,worldquest=true,waypoint=32306700,items={{id=183295,chance=100,class="Monk",specialization="Windwalker"},{id=183386,chance=100,class="Warrior",specialization="Fury"},{id=183341,chance=100,class="Rogue",specialization="Outlaw"}}},
                        {name="Theater of Pain Rares",id=162853,quest=62786,waypoint=50354728,items={{id=184062,mount=1437}}},
                        {name="Sabriel the Bonecleaver",id=168147,quest=58784,waypoint=50354728,covenantRequired=true,items={{id=181815,mount=1370,covenantOnly=true}}},
                        {name="Scunner",id=158406,quest=58006,waypoint=62107580,items={{id=181267,pet=2957}}},
                        {name="Pool of Mixed Monstrosities",id=157226,achievement=14721,waypoint=58197421},
                        {name="Violet Mistake",id=157309,quest=61720,waypoint=58197421,items={{id=182079,mount=1410}},notes={"To Summon: |cffff6666Red|r = |cff6666ffBlue|r > |cffffff66Yellow|r"}},
                        {name="Oily Invertebrate",id=48859,quest=61724,waypoint=58197421,items={{id=184155,quest=62804,transmog=true},{id=181270,pet=2960}},notes={"To Summon: 10 |cffff6666Red|r 10 |cff6666ffBlue|r 10 |cffffff66Yellow|r"}},
                        {name="Gelloh",id=157307,quest=61721,waypoint=58197421,notes={"To Summon: 15+ |cffffff66Yellow|r"}},
                        {name="Corrupted Sediment",id=48863,quest=61719,waypoint=58197421,notes={"To Summon: 15+ |cff6666ffBlue|r"}},
                        {name="Burnblister",id=48862,quest=61723,waypoint=58197421,notes={"To Summon: |cffff6666Red|r = |cffffff66Yellow|r > |cff6666ffBlue|r"}},
                        {name="Pulsing Leech",id=48854,quest=61718,waypoint=58197421,notes={"To Summon: 15+ |cffff6666Red|r"}},
                        {name="Boneslurp",id=48860,quest=61722,waypoint=58197421,notes={"To Summon: |cff6666ffBlue|r = |cffffff66Yellow|r > |cffff6666Red|r"}},
                        {name="Deadly Dapperling",id=162711,quest=58868,waypoint=76835707,items={{id=181263,pet=2953}}},
                        {name="Nerissa Heartless",id=162690,quest=58851,waypoint=66023532,items={{id=182084,mount=1373}}},
                        {name="Necromantic Anomaly",id=174108,quest=62369,waypoint=72872891,items={{id=181810,transmog=true}}},
                        {name="Bubbleblood",id=162727,quest=58870,waypoint=52663542,items={{id=184154,transmog=true},{id=184476,toy=true}}},
                        {name="Sister Chelicerae",id=159886,quest=58003,waypoint=55502361,items={{id=181172,pet=2948}}},
                        {name="Collector Kash",id=159105,quest=58005,waypoint=49012351},
                        {name="Devour'us",id=162669,quest=58835,waypoint=45052842},
                        {name="Corpsecutter Moroc",id=157058,quest=58335,waypoint=26392633},
                        {name="Gieger",id=162741,quest=58872,waypoint=31603540,covenantRequired=true,items={{id=182080,mount=1411,covenantOnly=true}}},
                        {name="Zargox the Reborn",id=157125,quest=59290,waypoint=28965138,items={{id=181804,transmog=true,covenantOnly=true}}},
                        {name="Warbringer Mal'korak",id=162819,quest=58889,waypoint=33718016,items={{id=182085,mount=1372}}},
                        {name="Tahonta",id=162586,quest=58783,waypoint=44215132,covenantRequired=true,items={{id=182075,mount=1366,covenantOnly=true}}},
                        {name="Deepscar",id=162797,quest=58878,waypoint=46734550},
                        {name="Gristlebeak",id=162588,quest=58837,waypoint=57795155},
                        {name="Indomitable Schmitd",id=161105,quest=58332,waypoint=38794333},
                        {name="Nirvaska the Summoner",id=161857,quest=58629,waypoint=50346328},
                        {name="Pesticide",id=162767,quest=58875,waypoint=53726132},
                        {name="Ravenomous",id=159753,quest=58004,waypoint=53841877,items={{id=181283,pet=2964}}},
                        {name="Smorgas the Feaster",id=162528,quest=58768,waypoint=42465345,items={{id=181266,pet=2956},{id=181265,pet=2955}}},
                        {name="Taskmaster Xox",id=160059,quest=58091,waypoint=50562011},
                        {name="Thread Mistress Leeda",id=162180,quest=58678,waypoint=24184297},
                    },
                },
                {
                    -- Revendreth
                    id = 1525,
                    covenant = 2,
                    faction = {2413, 2439},
                    currency = 1820,
                    rares = {
                        {name="Nurgash Muckformed",id=167526,quest=61814,worldquest=true,waypoint=27601460,items={{id=182638,chance=100,class="Death Knight",specialization="Unholy"},{id=183215,chance=100,class="Demon Hunter",specialization="Havoc"},{id=183376,chance=100,class="Warlock",specialization="Destruction"}}},
                        {name="Tollkeeper Varaboss",id=165253,quest=59595,waypoint=66507080},
                        {name="Harika the Horrid",id=165290,quest=59612,waypoint=45847919,covenantRequired=true,items={{id=180461,mount=1310,covenantOnly=true}}},
                        {name="Worldedge Gorger",id=160821,quest=58259,waypoint=38607200,items={{id=182589,mount=1391}}},
                        {name="Scrivener Lenua",id=160675,quest=58213,waypoint=38316914,items={{id=180587,pet=2893}}},
                        {name="Hopecrusher",id=166679,quest=59900,waypoint=51985179,items={{id=180581,mount=1298,covenantOnly=true}}},
                        {name="Soulstalker Doina",id=160392,quest=58130,waypoint=78934975},
                        {name="Endlurker",id=165206,quest=59582,waypoint=66555946,items={{id=179927}}},
                        {name="Famu the Infinite",id=166521,quest=59869,waypoint=62484716,items={{id=180582,mount=1379}}},
                        {name="Forgemaster Madalav",id=159496,quest=61618,waypoint=32641545,covenantRequired=true,items={{id=180939,transmog=true}}},
                        {name="Sire Ladinas",id=160857,quest=58263,waypoint=34045555,items={{id=180873,toy=true,chance=5}}},
                        {name="Amalgamation of Filth",id=166393,quest=59854,waypoint=53247300},
                        {name="Amalgamation of Light",id=164388,quest=59584,waypoint=25304850,items={{id=180688},{id=180586,pet=2892}}},
                        {name="Amalgamation of Sin",id=170434,quest=60836,waypoint=65782914},
                        {name="Azgar",id=166576,quest=59893,waypoint=35817052},
                        {name="Bog Beast",id=166292,quest=59823,waypoint=35003230,items={{id=180588,pet=2896}}},
                        {name="Executioner Aatron",id=166710,quest=59913,waypoint=37084742},
                        {name="Executioner Adrastia",id=161310,quest=58441,waypoint=43055183},
                        {name="Grand Arcanist Dimitri",id=167464,quest=60173,waypoint=20485298},
                        {name="Huntmaster Petrus",id=166993,quest=60022,waypoint=61717949,items={{id=180705,class="Hunter"}}},
                        {name="Innervus",id=160640,quest=58210,waypoint=21803590},
                        {name="Leeched Soul",id=165152,quest=59580,waypoint=67978179,items={{id=180585,pet=2897}}},
                        {name="Lord Mortegore",id=161891,quest=58633,waypoint=75976161},
                        {name="Manifestation of Wrath",id=170048,quest=60729,waypoint=49003490,items={{id=180585,pet=2897}}},
                        {name="Sinstone Hoarder",id=162481,quest=62252,waypoint=67443048},
                        {name="Stonefist",id=159503,quest=62220,waypoint=31312324},
                        {name="Tomb Burster",id=155779,quest=56877,waypoint=43007910,items={{id=180584,pet=2891}}},
                    },
                },
                {
                    -- Bastion
                    id = 1533,
                    covenant = 1,
                    faction = 2407,
                    rares = {
                        {name="Valinor <The Light of Eons>",id=167524,quest=61813,worldquest=true,waypoint=26602280,items={{id=183311,chance=100,class="Paladin",specialization="Retribution"},{id=183325,chance=100,class="Priest",specialization="Holy"},{id=183353,chance=100,class="Shaman",specialization="Elemental"}}},
                        {name="Sundancer",id=170548,quest=60862,waypoint=61409050,items={{id=180773,mount=1307}}},
                        {name="Wingflayer the Cruel",id=167078,quest=60314,waypoint=40635306,covenantRequired=true,items={{id=182749}}},
                        {name="Dark Watcher",id=170623,quest=60883,waypoint=27823014},
                        {name="Orstus & Sotiros",id=156339,quest=61634,covenantRequired=true,waypoint=22432285,items={{id=184397,pet=3062},{id=184401,pet=3063}}},
                        {name="Ascended Council",id=170899,quest=60977,waypoint=53498868,items={{id=183741,mount=1426}}},
                        {name="Enforcer Aegeon",id=171009,quest=60998,waypoint=51151953,items={{id=184404,toy=true}}},
                        {name="Unstable Memory",id=171008,quest=60997,waypoint=43482524,items={{id=184413,toy=true}}},
                        {name="Aspirant Eolis",id=171211,quest=61083,waypoint=32592336},
                        {name="Baedos",id=160629,quest={58648,62192},waypoint=51344080},
                        {name="Basilofos",id=170659,quest={60897,62158},waypoint=48985031},
                        {name="Beasts of Bastion",id=161527,quest={60570,60571,60569,58526},waypoint=55358024},
                        {name="Bookkeeper Mnemis",id=171189,quest=59022,waypoint=55826249,items={{id=182682}}},
                        {name="Cloudfeather Guardian",id=170932,quest={60978,62191},waypoint=50435804,items={{id=180812,pet=2925}}},
                        {name="Collector Astorestes",id=171014,quest=61002,waypoint=66004367},
                        {name="Corrupted Clawguard",id=171010,quest=60999,waypoint=56904778},
                        {name="Demi the Relic Hoarder",id=171011,quest={61069,61000},waypoint=37004180},
                        {name="Dionae",id=163460,quest=62650,waypoint=41354887,items={{id=180856,pet=2932}}},
                        {name="Echo of Aella <Hand of Courage>",id=171255,quest={61082,61091,62251},waypoint=45656550,items={{id=180062}}},
                        {name="Fallen Acolyte Erisne",id=160721,quest=58222,waypoint=60427305},
                        {name="Herculon",id=158659,quest={57705,57708},waypoint=42908265},
                        {name="Nikara Blackheart",id=160882,quest=58319,waypoint=51456859},
                        {name="Reekmonger",id=171327,waypoint=30365517},
                        {name="Selena the Reborn",id=160985,quest=58320,waypoint=61295090},
                    },
                },
                {
                    -- Ardenweald
                    id = 1565,
                    covenant = 3,
                    faction = {2465, 2464},
                    rares = {
                        {name="Oranomonos the Everbranching",id=167527,quest=61815,worldquest=true,waypoint=20606360,items={{id=183238,chance=100,class="Druid",specialization="Restoration"},{id=183261,chance=100,class="Hunter",specialization="Marksman"},{id=183274,chance=100,class="Mage",specialization="Fire"}}},
                        {name="Humon'gozz",id=164112,quest=59157,waypoint=32423026,items={{id=182650,mount=1415,chance=100}}},
                        {name="Valfir the Unrelenting",id=168647,quest=61632,waypoint=30115536,covenantRequired=true,items={{id=180730,mount=1393,covenantOnly=true},{id=182176,quest=62431,covenantOnly=true}}},
                        {name="Gormtamer Tizo",id=164107,quest=59145,waypoint=27885248,items={{id=180725,mount=1362,chance=100}}},
                        {name="Night Mare",id=168135,quest=60306,covenantOnly=true,waypoint=57874983,items={{id=180728,mount=1306,covenantOnly=true,chance=100}}},
                        {name="Hunter Vivanna",id=160448,quest=59221,waypoint=67465147,items={{id=179596,transmog=true},{id=183091,quest=62246}}},
                        {name="Deifir the Untamed",id=164238,quest={59201,62271},waypoint=47522845,items={{id=180631,pet=2920}}},
                        {name="Dustbrawl",id=163229,quest=58987,waypoint=48397717},
                        {name="Egg-Tender Leh'go",id=167851,quest=60266,waypoint=57862955},
                        {name="Faeflayer",id=171688,quest=61184,waypoint=68612765},
                        {name="Gormbore",id=163370,quest=59006,waypoint=54067601,items={{id=183196,pet=3035}}},
                        {hidden=true,name="Macabre",id=164093,quest=59140,waypoint=32664480,items={{id=180644,pet=2907}}},
                        {name="Mymaen",id=165053,quest=59431,waypoint=62102470},
                        {name="Mystic Rainbowhorn",id=164547,quest=59235,waypoint=65702809,items={{id=182179,quest=62434,covenantOnly=true}}},
                        {name="Old Ardeite",id=164391,quest={59208,62270},waypoint=51105740,items={{id=180643,pet=2908}}},
                        {name="Rootwrithe",id=167726,quest=60273,waypoint=65104430},
                        {name="Rotbriar Boggart",id=167724,quest=60258,waypoint=65702430,items={{id=175729}}},
                        {name="Soultwister Cero",id=171451,quest=61177,waypoint=72425175},
                        {name="Skuld Vit",id=164415,quest=59220,waypoint=37675917,covenantRequired=true,items={{id=182183,quest=62439,covenantOnly=true}}},
                        {name="The Slumbering Emperor",id=167721,quest=60290,waypoint=59304660,items={{id=175711}}},
                        {name="Wrigglemortis",id=164147,quest=59170,waypoint=58306180},
                    },
                },
            },
        },
        {
            name = "Battle for Azeroth",
            icon = 1869493,
            zones = {
                {
                    -- Mechagon
                    id = 1462,
                    color = "dbd9a9",
                    icon = 2735924,
                    rares = {
                        {name="Arachnoid Harvester",id=151934,quest=55512,waypoint=51604160,items={{id=168823,mount=1229}}},
                        {name="Rustfeather",id=152182,quest=55811,waypoint=65637850,items={{id=168370,mount=1248}}},
                    },
                },
                {
                    -- Nazjatar
                    id = 1355,
                    color = "4db3ea",
                    icon = 3012068,
                    currency = 1721,
                    rares = {
                        {name="Soundless",id=152290,quest=56298,waypoint=57605220,items={{id=169163,mount=1257}}},
                    },
                },
                {
                    -- Arathi Highlands
                    id = 14,
                    color = "f8f1bd",
                    icon = 236712,
                    rares ={
                        {name="Beastrider Kama",id=142709,questAlliance=53083,questHorde=53504,weekly=true,waypoint=65347116,items={{id=163644,mount=1180}}},
                        {name="Nimar the Slayer",id=142692,questAlliance=53091,questHorde=53517,weekly=true,waypoint=67486058,items={{id=163706,mount=1185}}},
                        {name="Overseer Krix",id=142423,questAlliance=53014,questHorde=53518,weekly=true,waypoint={32923847,27255710},items={{id=163646,mount=1182}}},
                        {name="Skullripper",id=142437,questAlliance=53022,questHorde=53526,weekly=true,waypoint=57154575,items={{id=163645,mount=1183}}},
                        {name="Knight-Captain Aldrin",id=142739,quest=53088,weekly=true,control="Horde",waypoint=48913996,items={{id=163578,mount=1173}}},
                        {name="Doomrider Helgrim",id=142741,quest=53085,weekly=true,control="Alliance",waypoint=53565764,items={{id=163579,mount=1174}}},
                    },
                },
                {
                    -- Darkshore
                    id = 62,
                    color = "f8f1bd",
                    icon = 236739,
                    rares = {
                        {name="Alash'anir",id=148787,questAlliance=54695,questHorde=54696,weekly=true,waypoint=56533078,items={{id=166432,mount=1200}}},
                        {name="Athil Dewfire",id=148037,quest=54431,weekly=true,waypoint=41607640,faction="Horde",items={{id=166803,mount=1203},{id=166449,pet=2544}}},
                        {name="Blackpaw",id=149651,quest=54890,weekly=true,waypoint=49682495,faction="Horde",items={{id=166428,mount=1199}}},
                        {name="Shadowclaw",id=149658,quest=54892,weekly=true,waypoint=39763269,faction="Horde",items={{id=166435,mount=1205}}},
                        {name="Agathe Wyrmwood",id=149652,quest=54883,weekly=true,waypoint=49502510,faction="Alliance",items={{id=166438,mount=1199}}},
                        {name="Croz Bloodrage",id=149661,quest=54886,weekly=true,waypoint=50703230,faction="Alliance",items={{id=166437,mount=1205}}},
                        {name="Moxo the Beheader",id=147701,quest=54277,weekly=true,waypoint=67241877,faction="Alliance",items={{id=166434,mount=1203}}},
                        {name="Frightened Kodo",id=148790,quest=132245,weekly=true,waypoint={41316548,44046756,41275401,38006600,39205650,44006500},items={{id=166433,mount=1201}}},
                    },
                },
                {
                    -- Uldum
                    id = 1527,
                    color = "f8f1bd",
                    icon = 409550,
                    rares = {
                        {name="Corpse Eater",id=162147,quest=58696,assault="AQR",waypoint=30854971,items={{id=174769,mount=1319}}},
                        {name="Rotfeaster",id=157146,quest=57273,assault="AMA",waypoint=68593204,items={{id=174753,mount=1317}}},
                        {name="Ishak of the Four Winds",id=157134,quest=57259,waypoint=73908353,items={{id=174641,mount=1314}}},
                        {name="Springfur Alpaca",id=162765,waypoint={15006200,24000900,27004800,30002900,39000800,41007000,47004800,52001900,55006900,62705340,63011446,70003900,76636813},items={{id=174859,mount=1329}}},
                    },
                },
                {
                    -- Vol'dun
                    id = 1195,
                    color = "d28b68",
                    icon = 2125384,
                    rares = {
                        {name="Elusive Alpaca",id=162681,waypoint={26405250,29006600,31106730,42006000,43006900,51108590,52508900,54008200,54605320,55007300},items={{id=174860,mount=1324}}},
                    },
                },
                {
                    -- Vale of Eternal Blossoms
                    id = 1530,
                    color = "b8dab6",
                    icon = 618798,
                    rares = {
                        {name="Anh-De the Loyal",id=157466,quest=57363,waypoint=34156805,items={{id=174840,mount=1328}}},
                        {name="Ha-Li",id=157153,quest=57344,waypoint={37323630,33973378,29053930,31524387,37313632,37323630},items={{id=173887,mount=1297}}},
                        {name="Houndlord Ren",id=157160,quest=57345,assault="MOG",waypoint={13132578,11833049,08953570},items={{id=174841,mount=1327}}},
                        {name="Rei Lun",id=157162,quest=57346,assault="MOG",waypoint=21901232,items={{id=174649,mount=1313}}},
                    },
                },
            },
        },
        {
            name = "Mists of Pandaria",
            icon = 630786,
            zones = {
                {
                    -- Kun-Lai Summit → Mogu'shan Vaults
                    name = "Mogu'shan Vaults",
                    id = 379,
                    color = "76fafb",
                    icon = 651996,
                    rares = {
                        {name="Elegon",id=60410,waypoint=60003800,instance=123123141,items={{id=87777,mount=478}}},
                    },
                },
            },
        },
        {
            name = "Cataclysm",
            icon = 630784,
            zones = {
                {
                    -- Northern Stranglethorn → Zul'Gurub
                    name = "Zul'Gurub",
                    id = 50,
                    color = "a7eb67",
                    icon = 135723,
                    rares = {
                        {name="Bloodlord Mandokir",id=52151,waypoint=72003280,instance=351263602,items={{id=68823,mount=410}}},
                        {name="High Priestess Kilnara",id=52059,waypoint=72003280,instance=351263602,items={{id=68824,mount=411}}},
                    },
                },
                {
                    -- Uldum → The Vortex Pinnacle
                    name = "The Vortex Pinnacle",
                    id = 249,
                    color = "96a3aa",
                    icon = 462522,
                    rares = {
                        {name="Altairus",id=43873,waypoint=77008400,instance=99999,items={{id=63040,mount=395}}},
                    },
                },
                {
                    -- Uldum → Throne of the Four Winds
                    name = "Throne of the Four Winds",
                    id = 249,
                    color = "96a3aa",
                    icon = 1035054,
                    rares = {
                        {name="Al'Akir",id=46753,waypoint=36008400,instance=99999,items={{id=63041,mount=396}}},
                    },
                },
                {
                    -- Mount Hyjal → Firelands
                    name = "Firelands",
                    id = 198,
                    color = "f19d4b",
                    icon = 512617,
                    rares = {
                        {name="Alysrazor",id=52530,waypoint=47007700,instance=351241394,items={{id=71665,mount=425}}},
                        {name="Ragnaros",id=52409,waypoint=47007700,instance=351241394,items={{id=69224,mount=415}}},
                    },
                },
                {
                    -- Caverns of Time → Dragon Soul
                    name = "Dragon Soul",
                    id = 75,
                    color = "f9d8fc",
                    icon = 609811,
                    rares = {
                        {name="Ultraxion",id=55294,waypoint=65005000,instance=1111111,items={{id=78919,mount=445}}},
                        {name="Deathwing",id=56173,waypoint=65005000,instance=1111111,items={{id=77067,mount=442},{id=77069,mount=444}}},
                    },
                },
            },
        },
        {
            name = "Wrath of the Lich King",
            icon = 630787,
            zones = {
                {
                    -- Icecrown → Icecrown Citadel
                    name = "Icecrown Citadel",
                    id = 118,
                    color = "c7fdfe",
                    icon = 236793,
                    rares = {
                        {name="The Lich King",id=36597,waypoint=54008500,instance=123123123123,items={{id=50818,mount=363,chance=1}}},
                    },
                },
                {
                    -- Storm Peaks → Ulduar
                    name = "Ulduar",
                    id = 120,
                    color = "9ffcfa",
                    icon = 254113,
                    rares = {
                        {name="Yogg-Saron",id=33288,waypoint=41001600,instance=31231231231,items={{id=45693,mount=304,chance=1}},notes={"Must be done on Hard Mode (Alone in the Dark)"}},
                    },
                },
            },
        },
        {
            name = "The Burning Crusade",
            icon = 630783,
            zones = {
                {
                    -- Deadwind Pass → Karazhan
                    name = "Karazhan",
                    id = 42,
                    color = "96a3aa",
                    icon = 1530372,
                    rares = {
                        {name="Attumen the Huntsman",id=16152,waypoint=47007700,instance=999999999,items={{id=30480,mount=168,chance=1}}},
                    },
                },
                {
                    -- Netherstorm → The Eye
                    name = "The Eye",
                    id = 109,
                    color = "e96944",
                    icon = 250117,
                    rares = {
                        {name="Kael'thas Sunstrider",id=19622,waypoint=74006500,instance=999999999,items={{id=32458,mount=183,chance=1.7}}},
                    },
                },
            },
        },
    },
    currencies = {
        {
            id = 1721, -- Prismatic Manapearl
            color = "4db3ea",
            icon = 463858,
        },
        {
            id = 1767, -- Stygia
            color = "e5cc80",
            icon = 3743739,
        },
        {
            id = 1820, -- Infused Ruby
            color = "f04c73",
            icon = 133250,
        },
        {
            id = 1931, -- Cataloged Research
            color = "dfd4ad",
            icon = 1506458,
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
}
