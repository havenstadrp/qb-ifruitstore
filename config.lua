Config = {}

-- Police required to start the heist
Config.RequiredCops = 0

-- Set Cooldown between each heist (in seconds)
Config.Cooldown = 20

-- Destroy The Security System / Thermite Minigame
Config.CorrectBlocks = 5
Config.IncorrectBlocks = 2
Config.TimeToShow = 5
Config.TimeToLose = 15

-- Set the different chances to steal an item
Config.ChanceForSamsungPhone = 85
Config.ChanceForIPhone = 70
Config.ChanceForTablet = 70
Config.ChanceForLaptop = 50

Config.Locations = {
    ["main"] = {
        x = 155.0067,
        y = -217.940,
        z = 54.349,
    },
    ["thermite"] = {
        x = 157.82,
        y = -225.63,
        z = 59.67,
        isDone = false,
        isBusy = false,
    },
    ["takeables"] = {
        [1] = {
            x = 158.8410,
            y = -225.547,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "tablet", amount = 2},
        },
        [2] = {
            x = 155.6237,
            y = -224.364,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "iphone", amount = 3},
        },
        [3] = {
            x = 150.2673,
            y = -222.627,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "samsungphone", amount = 3},
        },
        [4] = {
            x = 157.1467,
            y = -230.201,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "laptop", amount = 2},
        },
        [5] = {
            x = 153.9483,
            y = -229.066,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "laptop", amount = 2},
        },
        [6] = {
            x = 148.6617,
            y = -227.076,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "laptop", amount = 2},
        },
        [7] = {
            x = 145.3898,
            y = -225.979,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "laptop", amount = 2},
        },
        [8] = {
            x = 157.7198,
            y = -235.081,
            z = 54.423,
            isDone = false,
            isBusy = false,
            reward =  {name = "laptop", amount = 2}, -- This is for the headphones ("laptop" needs to be changed to "headphones")
        },
    },
    -- ["safe"] = {
    --     x = -625.37,
    --     y = -283.74,
    --     z = 35.57,
    --     isDone = false,
    --     isBusy = false,
    -- }
}

Config.MaleNoHandshoes = {[0] = true,[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,[6] = true,[7] = true,[8] = true,[9] = true,[10] = true,[11] = true,[12] = true,[13] = true,[14] = true,[15] = true,[18] = true,[26] = true,[52] = true,[53] = true,[54] = true,[55] = true,[56] = true,[57] = true,[58] = true,[59] = true,[60] = true,[61] = true,[62] = true,[112] = true,[113] = true,[114] = true,[118] = true,[125] = true,[132] = true,}

Config.FemaleNoHandshoes = {[0] = true,[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,[6] = true,[7] = true,[8] = true,[9] = true,[10] = true,[11] = true,[12] = true,[13] = true,[14] = true,[15] = true,[19] = true,[59] = true,[60] = true,[61] = true,[62] = true,[63] = true,[64] = true,[65] = true,[66] = true,[67] = true,[68] = true,[69] = true,[70] = true,[71] = true,[129] = true,[130] = true,[131] = true,[135] = true,[142] = true,[149] = true,[153] = true,[157] = true,[161] = true,[165] = true,}
