Config = {
    GarageInteriorCoords = vector3(-2204.52, 1094.4, 29.96), -- position d'arrivée lorsque l'on rentre dans le garage
    GarageInteriorHeaing = 172.72,
    maxVehicles = 50, -- nombre maximum de véhicules dans le garage
    vehiclesLocations = {
        {x = -2186.1774902344, y = 1083.3673095703, z =29.377265930176, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1086.6527099609, z =29.378057479858, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1089.8327636719, z =29.377294540405, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1093.1182861328, z =29.377941131592, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1096.3063964844, z =29.377490997314, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1103.0762939453, z =29.377382278442, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1106.2166748047, z =29.37787437439, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1109.6873779297, z =29.377098083496, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1112.9520263672, z =29.377624511719, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1116.1135253906, z =29.37734413147, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1119.5416259766, z =29.377395629883, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1122.9154052734, z =29.377222061157, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1126.0465087891, z =29.37739944458, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1129.3370361328, z =29.377237319946, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1132.7248535156, z =29.377265930176, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1135.8814697266, z =29.377225875854, heading = 89.417793273926},
        {x = -2186.1774902344, y = 1138.9117431641, z =29.377431869507, heading = 89.417793273926},

        {x = -2203.9020996094, y = 1114.9382324219, z =29.378356933594, heading = 269.44348144531},
        {x = -2203.9020996094, y = 1118.6451416016, z =29.377573013306, heading = 269.44348144531},
        {x = -2203.9020996094, y = 1122.4005126953, z =29.377647399902, heading = 269.44348144531},
        {x = -2203.9020996094, y = 1125.7840576172, z =29.378833770752, heading = 269.44348144531},
        {x = -2203.9020996094, y = 1129.1796875, z =29.377620697021, heading = 269.44348144531}
    },
    JobsGarages = {
        {job = "police", bucketId = 1, enteringCoords = vector3(-1075.84, -846.92, 4.88), MarkerColor = {0, 0, 255}}, -- job nécessaire, id de la dimension, coordonnées du point d'entrée
        {job = "ambulance", bucketId = 2, enteringCoords = vector3(-463.12, -341.48, 34.52), MarkerColor = {255, 0, 0}}
    },
    GenericJobPlate = {
        ["police"] = "LSPD",
        ["ambulance"] = "EMS"
    },

    BuyVehicleCoords = vector3(-659.04, -2369.56, 13.96),
    SpawnVehicleCoords = {
        coords = vector3(-668.93487548828, -2377.9318847656, 13.450407028198),
        heading = 61.121646881104
    },

    JobsVehicles = {
        ["police"] = {
            {name = "police", label = "Police Cruiser 1", price = 15000},
            {name = "police3", label = "Police Cruiser 2", price = 15000},
            {name = "police2", label = "Police Buffalo", price = 15000},
            {name = "police4", label = "Police Cruiser banalisée", price = 15000}
        },
        ["ambulance"] = {
            {name = "ambulance", label = "Ambulance", price = 15000}
        }
    }
}