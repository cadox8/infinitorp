Config = {}

Config.AlignMenu = "bottom-right"

Config.MotelPrice = 800
Config.HoraDeCobro = {["h"] = 22, ["m"]=0}

Config.Weapons = false 
Config.DirtyMoney = true 

Config.Debug = false

Config.MotelInterior = {
    ["exit"] = vector3(151.34562683105, -1007.6842041016, -98.999992370605),
    ["drawer"] = vector3(151.2417755127, -1003.018737793, -98.999992370605),
    ["wardrobe"] = vector3(151.71522521973, -1001.3452758789, -98.999977111816),
    ["invite"] = vector3(152.84375, -1007.8104248047, -99.0)
}

Config.ActionLabel = {
    ["exit"] = "Salir",
    ["drawer"] = "Cajón",
    ["wardrobe"] = "Armario",
    ["invite"] = "Invitar"
}

Config.ReconnectSpawn = {
    ["position"] = vector3(320.54, -231.74, 54.03)
}

Config.LandLord = {
    ["Motel Rebelion"] = {
        Key = "PinkCageMotel",
        Position = vector3(325.01959228516, -229.5560760498, 54.221176147461),
        MotelsEntrances = {
            [1] = vector3(312.96322631836, -218.5948638916, 54.221771240234),
            [2] = vector3(310.96774291992, -217.81716918945, 54.221771240234),
            [3] = vector3(307.30145263672, -216.61219787598, 54.221771240234),
            [4] = vector3(307.70816040039, -213.3956451416, 54.221771240234),
            [5] = vector3(309.65942382813, -208.16549682617, 54.221771240234),
            [6] = vector3(313.52093505859, -198.16625976563, 54.221775054932),
            [7] = vector3(315.78137207031, -194.87210083008, 54.226440429688),
            [8] = vector3(319.16732788086, -196.6743927002, 54.226455688477),
            [9] = vector3(321.14105224609, -197.32002258301, 54.226455688477),
            [10] = vector3(311.38592529297, -203.59060668945, 54.221775054932),
            [11] = vector3(312.92715454102, -218.70674133301, 58.019248962402),
            [12] = vector3(311.02416992188, -217.88179016113, 58.019248962402),
            [13] = vector3(307.35223388672, -216.50700378418, 58.01921081543),
            [14] = vector3(307.75787353516, -213.50387573242, 58.019248962402),
            [15] = vector3(309.78897094727, -208.13804626465, 58.019248962402),
            [16] = vector3(311.65594482422, -203.6040802002, 58.019248962402),
            [17] = vector3(313.45355224609, -198.26907348633, 58.019214630127),
            [18] = vector3(315.65441894531, -194.87507629395, 58.019214630127),
            [19] = vector3(319.19891357422, -196.36817932129, 58.019214630127),
            [20] = vector3(321.16479492188, -197.19439697266, 58.019218444824),
            [21] = vector3(329.38122558594, -224.86923217773, 54.22180557251),
            [22] = vector3(331.49880981445, -225.41708374023, 54.22180557251),
            [23] = vector3(335.14532470703, -227.01698303223, 54.22180557251),
            [24] = vector3(336.76617431641, -224.61317443848, 54.221809387207),
            [25] = vector3(338.63681030273, -219.24388122559, 54.221817016602),
            [26] = vector3(340.43328857422, -214.77523803711, 54.221817016602),
            [27] = vector3(342.68362426758, -209.43200683594, 54.221817016602),
            [28] = vector3(344.32986450195, -204.81706237793, 54.221809387207),
            [29] = vector3(346.38806152344, -199.60670471191, 54.221809387207),
            [30] = vector3(329.39547729492, -224.89248657227, 58.019245147705),
            [31] = vector3(331.39825439453, -225.66204833984, 58.019245147705),
            [32] = vector3(334.89376831055, -227.13185119629, 58.019245147705),
            [33] = vector3(336.84780883789, -224.65908813477, 58.019245147705),
            [34] = vector3(338.85153198242, -219.31286621094, 58.019237518311),
            [35] = vector3(340.47213745117, -214.57499694824, 58.019237518311),
            [36] = vector3(342.56774902344, -209.27154541016, 58.019237518311),
            [37] = vector3(344.37359619141, -204.82313537598, 58.019237518311),
            [38] = vector3(346.62841796875, -199.55404663086, 58.019237518311),
        }
    }
}

Config.HelpTextMessage = "-1 ~INPUT_CELLPHONE_LEFT~ & ~INPUT_CELLPHONE_RIGHT~ +1 ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_FRONTEND_RDOWN~ Confirmar y comprar habitación por ($" .. Config.MotelPrice .. ") ~n~"
Config.HelpTextMessage = Config.HelpTextMessage .. "~INPUT_FRONTEND_CANCEL~ Cancelar ~n~"



Config.GenerateUniqueId = function()
    math.randomseed(GetGameTimer() + math.random())

    return math.random(1000000, 9999999)
end