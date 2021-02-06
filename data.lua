local name, ravShadowlands = ...

-- The order of the data represents the order presented by the
-- Addon's Interface.
ravShadowlands.data = {
    zones = {
        {
            -- Maldraxxus
            id = 1536,
            covenant = 4,
            color = "40bf40",
            icon = "3257749",
            rares = {
                {
                    id = 162819,
                    name = "Warbringer Mal'korak",
                    waypoint = {33.7, 80.1},
                    quest = 58889,
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
                    waypoint = {66.1, 35.3},
                    quest = 58851,
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
                    waypoint = {44.2, 51.1},
                    quest = 58783,
                    items = {
                        {
                            id = 182075,
                            mount = 1366,
                        },
                    },
                },
                {
                    id = 162741,
                    name = "Gieger",
                    waypoint = {31.5, 35.3},
                    quest = 58837,
                    items = {
                        {
                            id = 182080,
                            mount = 1411,
                            covenantOnly = true,
                        },
                    },
                },
                {
                    id = 174108,
                    name = "Necromatic Anomaly",
                    waypoint = {72.4, 28.6},
                    quest = 58889,
                    items = {
                        {
                            id = 181810,
                        },
                    },
                },
                {
                    id = 157309,
                    name = "Violet Mistake",
                    waypoint = {31.5, 35.3},
                    quest = 61720,
                    items = {
                        {
                            id = 182079,
                            mount = 1410,
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
                    id = 166521,
                    name = "Famu the Infinite",
                    waypoint = {62.4, 47.1},
                    quest = 59869,
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
                    waypoint = {45.3, 79.3},
                    quest = 59612,
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
                    waypoint = {52.0, 51.8},
                    quest = 59900,
                    items = {
                        {
                            id = 180581,
                            mount = 1298,
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
                    id = 174827,
                    name = "Gorged Shadehound",
                    waypoint = {62.4, 47.1},
                    -- quest = 61124,
                    items = {
                        {
                            id = 184167,
                            mount = 1304,
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
                    id = 170548,
                    name = "Sundancer",
                    waypoint = {60.0, 93.6},
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
                    waypoint = {60.0, 93.6},
                    quest = 60314,
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
                    waypoint = {60.0, 93.6},
                    quest = 60883,
                    items = {
                        {
                            id = 184297,
                        },
                    },
                },
                {
                    id = 156339,
                    name = "Orstus and Sotiros",
                    waypoint = {60.0, 93.6},
                    quest = 61634,
                    items = {
                        {
                            id = 184365,
                        },
                    },
                },
                {
                    id = 170832,
                    name = "Ascended Council",
                    waypoint = {60.0, 93.6},
                    quest = 60977,
                    items = {
                        {
                            id = 183741,
                            mount = 1426,
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
                    id = 164112,
                    name = "Humon'gozz",
                    waypoint = {32.5, 30.5},
                    quest = 59157,
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
                    waypoint = {30.3, 56.0},
                    quest = 61632,
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
                    waypoint = {30.3, 56.0},
                    quest = 59145,
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
                    name = "Swift Gloomhoof",
                    waypoint = {30.3, 56.0},
                    quest = 60306,
                    items = {
                        {
                            id = 180728,
                            mount = 1306,
                            guaranteed = true,
                        },
                    },
                },
            }
        },
    },
}
