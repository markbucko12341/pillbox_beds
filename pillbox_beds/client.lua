ESX = nil
local InAction = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for i=1, #Config.BedList do
            local bedID   = Config.BedList[i]
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z, true)
            if distance < Config.MaxDistance and InAction == false then
                ESX.Game.Utils.DrawText3D({ x = bedID.objCoords.x, y = bedID.objCoords.y, z = bedID.objCoords.z + 1 }, 'Press [E] to lay down', 0.6)
                if IsControlJustReleased(0, 38) then
                    bedActive(bedID.objCoords.x, bedID.objCoords.y, bedID.objCoords.z, bedID.heading, bedID)
                end
            end
        end
    end
end)

function bedActive(x, y, z, heading)
    SetEntityCoords(GetPlayerPed(-1), x, y, z + 0.3)
    RequestAnimDict('anim@gangops@morgue@table@')
    while not HasAnimDictLoaded('anim@gangops@morgue@table@') do
        Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), 'anim@gangops@morgue@table@' , 'ko_front' ,8.0, -8.0, -1, 1, 0, false, false, false )
    SetEntityHeading(GetPlayerPed(-1), heading + 180.0)
    InAction = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if InAction == true then
                headsUp('Press ~INPUT_VEH_DUCK~ to get back up')
                if IsControlJustReleased(0, 73) then
                    ClearPedTasks(GetPlayerPed(-1))
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    SetEntityCoords(GetPlayerPed(-1), x + 1.0, y, z)
                    InAction = false
                end
            end
        end
    end)
end

function headsUp(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end