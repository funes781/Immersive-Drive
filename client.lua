local offroadClasses = {
    [8] = true, -- Motorcycles
    [9] = true, -- Offroad vehicles
    [10] = true, -- Industrial vehicles
    [11] = true, -- Utility vehicles
    [18] = true, -- Emergency vehicles
    [19] = true, -- Military vehicles
    [22] = true  -- SUVs
}

function isOffroadSurface(vehicle)
    local materialHash = GetVehicleWheelSurfaceMaterial(vehicle, 0)
    local offroadMaterials = {
        [-1595148316] = true, 
        [1333033863] = true,  
        [510490462] = true,   
        [-700658213] = true,  
    }

    return offroadMaterials[materialHash] == true
end

function applyOffroadHandlingPenalty(vehicle)
    local currentTraction = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax')
    local reducedTraction = currentTraction * 0.6
    SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax', reducedTraction)
end

function applyVehicleTurbulence(vehicle)
    local randomX = math.random(-2, 2) / 10.0
    local randomY = math.random(-2, 2) / 10.0
    local randomZ = math.random(-2, 2) / 10.0
    ApplyForceToEntity(vehicle, 1, randomX, randomY, randomZ, 0, 0, 0, true, true, true, true, true, true)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleClass = GetVehicleClass(vehicle)

            if not offroadClasses[vehicleClass] then
                if isOffroadSurface(vehicle) then
                    applyOffroadHandlingPenalty(vehicle)
                    applyVehicleTurbulence(vehicle)
                end
            end
        end
    end
end)
