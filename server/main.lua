-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local alarmTriggered = false
local certificateAmount = 43

-- Events

RegisterNetEvent('qb-ifruitstore:server:LoadLocationList', function()
    local src = source
    TriggerClientEvent("qb-ifruitstore:server:LoadLocationList", src, Config.Locations)
end)

RegisterNetEvent('qb-ifruitstore:server:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
    TriggerClientEvent('qb-ifruitstore:client:setSpotState', -1, stateType, state, spot)
end)

RegisterNetEvent('qb-ifruitstore:server:SafeReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(1500, 2000), "robbery-ifruit")
    Player.Functions.AddItem("certificate", certificateAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["certificate"], "add")
    Wait(500)
    local luck = math.random(1, 100)
    if luck <= 10 then
        Player.Functions.AddItem("goldbar", math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldbar"], "add")
    end
end)

RegisterNetEvent('qb-ifruitstore:server:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
    TriggerClientEvent('qb-ifruitstore:client:SetSafeStatus', -1, stateType, state)
end)

RegisterNetEvent('qb-ifruitstore:server:itemReward', function(spot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.Locations["takeables"][spot].reward

    if Player.Functions.AddItem(item.name, item.amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'add')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You have to much in your pocket ..', 'error')
    end
end)

RegisterServerEvent("qb-ifruitstore:server:PoliceAlertMessage1")
AddEventHandler("qb-ifruitstore:server:PoliceAlertMessage1", function ()
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayer()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police") then
                local data = {displayCode = "10-11A", description = "iFruit Robbery", isImportant = 1,
                    recipientList = {"police"}, length = "10000", infoM = "fas fa-mobile", info = "iFruit Store Robbery On Going..", blackSprite = 619, blipColour = 50, blipScale = 1.0}
                local dispatchData = {dispatchData = data, caller = "Alarm", coords = vector3(370.52, 103.84, 103.13)}
                TriggerEvent("wf-alerts:svNotify", dispatchData)
            end
        end
    end
end)

RegisterServerEvent("qb-ifruitstore:server:PoliceAlertMessage2")
AddEventHandler("qb-ifruitstore:server:PoliceAlertMessage2", function ()
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayer()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police") then
                local data = {displayCode = "10-11B", description = "Power Box Tampering", isImportant = 0,
                    recipientList = {"police"}, length = "5000", infoM = "fas fa-bolt", info = "Someone is tamptering with the iFruit Store Power Box..", blipSprite = 769, blipColour = 66, blipScale = 0.7}
                local dispatchData = {dispatchData = data, caller = "Local", coords = vector3(363.29, 74.26, 97.97)}
                TriggerEvent("wf-alerts:svNotify", dispatchData)
            end
        end
    end
end)

RegisterServerEvent("qb-ifruitstore:server:PoliceAlertMessage3")
AddEventHandler("qb-ifruitstore:server:PoliceAlertMessage3", function ()
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayer()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police") then
                local data = {displayCode = "10-11C", description = "Power Cut", isImportant = 0,
                    recipientList = {"police"}, length = "5000", infoM = "fas fa-bolt", info = "The power has gone out unexpectedly at the iFruit Store", blipSprite = 769, blipColour = 66, blipScale = 0.4}
                local dispatchData = {dispatchData = data, caller = "Alarm", coords = vector3(370.82, 104.09, 103.13)}
                TriggerEvent("wf-alerts:svNotify", dispatchData)
            end
        end
    end
end)

-- RegisterNetEvent('qb-ifruitstore:server:callCops', function(streetLabel, coords)
--     TriggerClientEvent("qb-ifruitstore:client:robberyCall", -1, streetLabel, coords)
-- end)

-- Register Cooldown Event
RegisterServerEvent("qb-ifruitstore:server:BeginCooldown", function ()
    Cooldown = true
    local timer = Config.Cooldown
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

-- Register Security Status
RegisterServerEvent("qb-ifruitstore:server:SetSecurityStatus", function (stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
    TriggerClientEvent("qb-ifruitstore:client:SetSecurityStatus", -1, stateType, state)
end)

-- Creating Usable Items
QBCore.Functions.CreateUseableItem("thermite", function (source)
    local player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent("thermite:UseThermite", source)
end)

-- Callback For Cooldown
QBCore.Functions.CreateCallback("qb-ifruitstore:callback:Cooldown", function (source, cb)
    if Cooldown then
        cb(true)
    else
        cb(false)
    end
end)