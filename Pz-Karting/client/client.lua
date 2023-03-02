local QBCore = exports['qb-core']:GetCoreObject()
Config = Config or {}
hascarro = false

function spawncarro()
    local carro = 'veto'
    RequestModel(carro)
        while not HasModelLoaded(carro) do
            Wait(100)
        end

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        local vehicle = CreateVehicle(carro, coords.x - 1 , coords.y + 0.75, coords.z, GetEntityHeading(ped), true, false)
        SetPedIntoVehicle(ped, vehicle, -1)
        SetVehicleNumberPlateText(vehicle, "VETO")
        SetVehicleColours(vehicle, 0, 0)
        SetVehicleEnginePowerMultiplier(vehicle, 50.0)
        exports['Legacy-Fuel']:SetFuel(vehicle, 100.0)
        QBCore.Functions.Notify('Go-carro rented', 'success', 4000)
        hascarro = true
end -- spawncarro

CreateThread(function()
    exports['qb-target']:SpawnPed({
        model = Config.PedModel,
        coords = vector4(-155.1, -2151.96, 15.71, 357.05), 
        minusOne = false, 
        freeze = true, 
        invincible = true, 
        blockevents = true,
        target = { 
            options = {
                {
                    type = 'client',
                    event = 'pz-carro',
                    icon = 'fas fa-car',
                    label = 'Rent a go-carro',
                },
                {
                    type = 'client',
                    event = 'return-carro',
                    icon = 'fas fa-key',
                    label = 'Return the go-carro',
                    
                    canInteract = function()
                        if hascarro then return true else return false end
                    end
                },
                distance = 1.5
            },
        },
    })
end)

RegisterNetEvent('pz-carro', function()
    spawncarro()
end)

RegisterNetEvent('return-carro', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        hascarro = false
    end
    QBCore.Functions.Notify('Go-carro returned', 'success', 4000)
end)