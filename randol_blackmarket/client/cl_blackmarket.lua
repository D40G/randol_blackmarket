local QBCore = exports['qb-core']:GetCoreObject()
local PlayerJob = {}
------------------------------
 -- RESOURCE START/LOAD IN --
------------------------------
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        PlayerJob = QBCore.Functions.GetPlayerData().job
        LocateGuy()
    end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    LocateGuy()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)


function LocateGuy()
    exports['qb-target']:AddBoxZone("locateguy", vector3(-1054.96, -243.53, 44.02), 1.0, 1.0, {
        name="locateguy",
        heading=30,
        --debugPoly=true,
        minZ=43.82,
        maxZ=44.62,
    }, {
        options = {
            {
                event = "randol_blackmarket:client:tracktheguy",
                icon = "fa-solid fa-location-dot",
                label = "Track Dealer",
            },
        },
        distance = 2.5
    })
end



function DeleteMarketGuy()
    if DoesEntityExist(marketguy) then
        DeletePed(marketguy)
    end
end

function TrackBlip()
	tracked = AddBlipForCoord(findme.x, findme.y, findme.z)
    SetBlipSprite(tracked, 162)
    SetBlipColour(tracked, 1)
    SetBlipAlpha(tracked, 200)
    SetBlipDisplay(tracked, 4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Dealer Location")
    EndTextCommandSetBlipName(tracked)

    SetTimeout(120000, function() --2 minutes then removes blip from map.
        QBCore.Functions.Notify("Blip has expired.", 'error')
        RemoveBlip(tracked)
    end)
end


CreateThread(function()
    while true do
        Wait(5)
        local hours = GetClockHours()
        if hours >= Config.Open or hours < Config.Close then
                RequestModel(GetHashKey(Config.Model))
                while not HasModelLoaded(GetHashKey(Config.Model)) do
                    Wait(0)
                end

                if not DoesEntityExist(marketguy) then

                    local pickaspotbro = math.random(#Config.Locations)
                
                    marketguy = CreatePed(0, GetHashKey(Config.Model) , Config.Locations[pickaspotbro].x, Config.Locations[pickaspotbro].y, Config.Locations[pickaspotbro].z, Config.Locations[pickaspotbro].w, false, false)

                    SetEntityAsMissionEntity(marketguy)
                    SetPedFleeAttributes(marketguy, 0, 0)
                    SetBlockingOfNonTemporaryEvents(marketguy, true)
                    SetEntityInvincible(marketguy, true)
                    FreezeEntityPosition(marketguy, true)
                    TaskStartScenarioInPlace(marketguy, "WORLD_HUMAN_AA_SMOKE", 0, true)

                    exports['qb-target']:AddTargetEntity(marketguy, {
                        options = {
                            { 
                                icon = "fa-solid fa-comments",
                                label = "Talk to Stranger",
                                action = function(entity)
                                    TriggerEvent('animations:client:EmoteCommandStart', {"think4"})
                                    QBCore.Functions.Progressbar("negotiate", "Checking your credentials..", 7500, false, false, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function()
                                        ClearPedTasks(PlayerPedId())
                                        if PlayerJob.name ~= "police" then
                                            exports['qb-menu']:openMenu({
                                                {
                                                    header = "Blackmarket",
                                                    isMenuHeader = true
                                                },
                                                {
                                                    header = "View Products",
                                                    icon = "fa-solid fa-box-open",
                                                    params = {
                                                        event = 'randol_blackmarket:openshop'
                                                    }
                                                },
                                                {
                                                    header = "Close menu",
                                                    txt = "",
                                                    icon = "fa-solid fa-angle-left",
                                                    params = {
                                                        event = 'qb-menu:closeMenu'
                                                    }
                                                },
                                            })
                                        else
                                            QBCore.Functions.Notify("Get away from me piggy!", "error")
                                        end
                                    end)
                                end,
                            },
                        },
                        distance = 2.5,
                    })
                end
        else
            DeleteMarketGuy()
        end
    end
end)

--------------------
-- OPEN STORE --
--------------------

RegisterNetEvent("randol_blackmarket:openshop", function()
	TriggerServerEvent("inventory:server:OpenInventory", "shop", "illegalshit", Config.Goodies)
end)

function HackingSuccess(success)
    if success then
        TriggerEvent('mhacking:hide')
        findme = GetEntityCoords(marketguy)
        SetNewWaypoint(findme.x, findme.y)
        TrackBlip()
        QBCore.Functions.Notify("Dealer found. Their location is now marked on your GPS", "primary", 6000)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    else
        TriggerEvent('mhacking:hide')
        QBCore.Functions.Notify("You failed the hack.", "error")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end
end


RegisterNetEvent('randol_blackmarket:client:tracktheguy')
AddEventHandler('randol_blackmarket:client:tracktheguy', function()
    if DoesEntityExist(marketguy) then
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        QBCore.Functions.Progressbar("locate_guy", "Attempting to locate the dealer..", 10500, false, false, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"texting"})
        Wait(2000)
        TriggerEvent("mhacking:show")
	    TriggerEvent("mhacking:start", 6, 15, HackingSuccess)
        end)
    else
        QBCore.Functions.Notify("It's too early to do this. Come back later.", "error")
    end
end)

-------------------------------------------------------------------------------
-- DEBUG COMMAND (MAKE SURE YOU COMMENT THIS OUT WHEN YOU'RE DONE DEBUGGING) --
-------------------------------------------------------------------------------

-- RegisterCommand('tpdealer', function()
--     if DoesEntityExist(marketguy) then
--         findme = GetEntityCoords(marketguy)
--         SetEntityCoords(PlayerPedId(), findme)
--     else
--         QBCore.Functions.Notify("Unable to locate the dealer at this time. He must be sleeping.", "error", 6000)
--     end
-- end)


--------------------
-- RESOURCE STOP --
--------------------

AddEventHandler('onResourceStop', function(resourceName) 
	if GetCurrentResourceName() == resourceName then
        DeleteMarketGuy()
        exports['qb-target']:RemoveZone("locateguy")
	end 
end)
