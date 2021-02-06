local name, ravShadowlands = ...

-- The order of the data represents the order presented by the
-- Addon's Interface.
ravShadowlands.data = {
    zones = {
        {
            -- Maldraxxus
            id = 1536,
            color = "40bf40",
            bosses = {
                {
                    id = 162819,
                    name = "Warbringer Mal'korak",
                    waypoint = {33.7, 80.1},
                    quest = 58889,
                    item = 182085,
                    mount = 1372,
                },
                {
                    id = 162690,
                    name = "Nerissa Heartless",
                    waypoint = {66.1, 35.3},
                    quest = 58851,
                    item = 182084,
                    mount = 1373,
                },
                {
                    id = 162586,
                    name = "Tahonta",
                    waypoint = {44.2, 51.1},
                    quest = 58783,
                    item = 182075,
                    mount = 1366,
                },
                {
                    id = 162741,
                    name = "Gieger",
                    waypoint = {31.5, 35.3},
                    quest = 58837,
                    covenantOnly = true,
                    item = 182080,
                    mount = 1411,
                },
                {
                    id = 174108,
                    name = "Necromatic Anomaly",
                    waypoint = {72.4, 28.6},
                    quest = 58889,
                    item = 181810,
                },
                {
                    id = 157309,
                    name = "Violet Mistake",
                    waypoint = {31.5, 35.3},
                    quest = 61720,
                    item = 182079,
                    mount = 1410,
                },
            }
        },
        {
            -- Revendreth
            id = 1525,
            color = "ff4040",
            bosses = {
                {
                    id = 166521,
                    name = "Famu the Infinite",
                    waypoint = {62.4, 47.1},
                    quest = 59869,
                    item = 180582,
                    mount = 1379,
                },
                {
                    id = 165290,
                    name = "Harika the Horrid",
                    waypoint = {45.3, 79.3},
                    quest = 59612,
                    item = 180461,
                    mount = 1310,
                },
                {
                    id = 166679,
                    name = "Hopecrusher",
                    waypoint = {52.0, 51.8},
                    quest = 59900,
                    item = 180581,
                    mount = 1298,
                },
            }
        },
        {
            -- Bastion
            id = 1533,
            color = "68ccef",
            bosses = {
                {
                    id = 170548,
                    name = "Sundancer",
                    waypoint = {60.0, 93.6},
                    item = 180773,
                    mount = 1307,
                },
                {
                    id = 170832,
                    name = "Ascended Council",
                    waypoint = {60.0, 93.6},
                    quest = 60977,
                    item = 183741,
                    mount = 1426,
                },
            }
        },
        {
            -- Ardenweald
            id = 1565,
            color = "8b55d7",
            bosses = {
                {
                    id = 164112,
                    name = "Humon'gozz",
                    waypoint = {32.5, 30.5},
                    quest = 59157,
                    item = 182650,
                    mount = 1415,
                },
                {
                    id = 168647,
                    name = "Valfir the Unrelenting",
                    waypoint = {30.3, 56.0},
                    quest = 61632,
                    item = 180730,
                    mount = 1393,
                },
                {
                    id = 164107,
                    name = "Gormtamer Tizo",
                    waypoint = {30.3, 56.0},
                    quest = 59145,
                    item = 180725,
                    mount = 1362,
                },
                {
                    id = 168135,
                    name = "Swift Gloomhoof",
                    waypoint = {30.3, 56.0},
                    quest = 60306,
                    item = 180728,
                    mount = 1306,
                },
            }
        },
    },
}
