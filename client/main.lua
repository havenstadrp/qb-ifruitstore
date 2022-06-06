-- Constants
local ROBBERY = "robbery"
local POWEROUTAGE = "poweroutage"
local POWERBOXEXPLOSION = "powerboxexplosion"

-- Variables

local QBCore = exports['qb-core']:GetCoreObject()
local currentFires = {}
local CurrentCops = 0
local copsCalled = false
local requiredItemsShowed = false
local requiredItemsShowed2 = false
local requiredItems = {}
local currentSpot = 0
local usingSafe = false

-- Functions

function lockpickDone(success)
    local pos = GetEntityCoords(PlayerPedId())
    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if success then
        GrabItem(currentSpot)
    else
        if math.random(1, 100) <= 40 and IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            QBCore.Functions.Notify("You ripped your glove..")
        end
        if math.random(1, 100) <= 10 then
            TriggerServerEvent("QBCore:Server:RemoveItem", "advancedlockpick", 1)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["advancedlockpick"], "remove")
        end
    end
end

-- Alarming the police
function PoliceAlertMessage(dispatch)
    if dispatch == "robbery" then
        exports['ps-dispatch']:IFruitStoreRobbery()
        copsCalled = true
    elseif dispatch == "poweroutage" then
        exports['ps-dispatch']:PowerOutage()
    elseif dispatch == "powerboxexplosion" then
        exports['ps-dispatch']:PowerBoxExplosion()
    else
        print("Dispatch type isn't recognized! This will be ignored!")
    end
end

-- Grabbing item from the store
function GrabItem(spot)
    local pos = GetEntityCoords(PlayerPedId())
    if requiredItemsShowed2 then
        requiredItemsShowed2 = false
        TriggerEvent("inventory:client:requiredItems", requiredItems, false)
    end
    QBCore.Functions.Progressbar("grab_ifruititem", "Disconnect Item", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        flags = 16,
    }, {}, {}, function ()
        if not copsCalled then
            local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
            local street1 = GetStreetNameFromHashKey(s1)
            local street2 = GetStreetNameFromHashKey(s2)
            local streetLabel = street1
            if street2 ~= nil then
                streetLabel = streetLabel .. " " .. street2
            end

            local chance = math.random(1,100)
            -- Start debugging
            print(chance)
            -- Stop debugging

            if Config.Locations["thermite"].isDone then
                -- 30% chance of triggering the alarm
                if chance <= 30 then
                    PoliceAlertMessage(ROBBERY)
                end
            else
                -- 70% chance of triggering the alarm
                if chance <= 70 then
                    PoliceAlertMessage(ROBBERY)
                end
            end
        end
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        TriggerServerEvent("qb-ifruitstore:server:setSpotState", "isDone", true, spot)
        TriggerServerEvent("qb-ifruitstore:server:setSpotState", "isBusy", false, spot)
        TriggerServerEvent("qb-ifruitstore:server:itemReward", spot)
    end, function ()
        StopAnimTask(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
        TriggerServerEvent("qb-ifruitstore:server:setSpotState", "isBusy", false, spot)
        QBCore.Functions.Notify("Canceled..", "error")
    end)
end

-- function GrabItem(spot)
--     local pos = GetEntityCoords(PlayerPedId())
--     if requiredItemsShowed2 then
--         requiredItemsShowed2 = false
--         TriggerEvent('inventory:client:requiredItems', requiredItems, false)
--     end
--     QBCore.Functions.Progressbar("grab_ifruititem", "Disconnect Item", 10000, false, true, {
--         disableMovement = true,
--         disableCarMovement = true,
--         disableMouse = false,
--         disableCombat = true,
--     }, {
--         animDict = "anim@gangops@facility@servers@",
--         anim = "hotwire",
--         flags = 16,
--     }, {}, {}, function() -- Done
--         if not copsCalled then
-- 			local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
--             local street1 = GetStreetNameFromHashKey(s1)
--             local street2 = GetStreetNameFromHashKey(s2)
--             local streetLabel = street1
--             if street2 ~= nil then
--                 streetLabel = streetLabel .. " " .. street2
--             end
--             -- if Config.SmallBanks[closestBank]["alarm"] then
--                 TriggerServerEvent("qb-ifruitstore:server:callCops", streetLabel, pos)
--                 copsCalled = true
--             -- end
--         end

--         StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
--         TriggerServerEvent('qb-ifruitstore:server:setSpotState', "isDone", true, spot)
--         TriggerServerEvent('qb-ifruitstore:server:setSpotState', "isBusy", false, spot)
--         TriggerServerEvent('qb-ifruitstore:server:itemReward', spot)
--         TriggerServerEvent('qb-ifruitstore:server:PoliceAlertMessage', 'People try to steal items at the iFruit Store', pos, true)
--     end, function() -- Cancel
--         StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
--         TriggerServerEvent('qb-ifruitstore:server:setSpotState', "isBusy", false, spot)
--         QBCore.Functions.Notify("Canceled..", "error")
--     end)
-- end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == `mp_m_freemode_01` then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function takeAnim()
    local ped = PlayerPedId()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function ThermiteAnimation()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel("hei_p_m_bag_var22_arm_s")
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
    local ped = PlayerPedId()
    SetEntityHeading(ped, 297)
    Citizen.Wait(100)

    local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(PlayerPedId())))
    local bagscene = NetworkCreateSynchronisedScene(157.82 + 0.25, -225.63, 59.67, rotx, roty, rotz + 297, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), 157.79, -225.67, 59.67, true, true, false)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.2, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    Citizen.Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    print("x = " .. x .. "\ny = " .. y .. "\nz = " .. z)
    local bomb = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.3, true, true, true)

    SetEntityCollision(bomb, false, true)
    AttachEntityToEntity(bomb, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(2000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomb, 1, 1)
    FreezeEntityPosition(bomb, true)
    TriggerServerEvent("qb-ifruitstore:server:SetThermiteCharge", method)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    NetworkStopSynchronisedScene(bagscene)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
    Citizen.Wait(5000)
    ClearPedTasks(ped)
    DeleteObject(bomb)
    StopParticleFxLooped(effect, 0)
end

function CreateFire(coords, time)
    for i = 1, math.random(1, 7), 1 do
        TriggerServerEvent("qb-ifruitstore:server:StartThermiteFire", coords, 24, false)
    end
    Wait(time)
    TriggerServerEvent("qb-ifruitstore:server:StopThermiteFire")
end

-- Hack Security Successfully
function ThermiteSuccess()
    QBCore.Functions.Notify("You successfully hacked the security system!", "success")
    TriggerServerEvent("qb-ifruitstore:server:BeginCooldown")
    TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
    local pos = GetEntityCoords(PlayerPedId())
    if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y, Config.Locations["thermite"].z)) < 1.5 then
        TriggerServerEvent("qb-ifruitstore:server:SetSecurityStatus", "isDone", true)
        TriggerServerEvent("qb-ifruitstore:server:SetSecurityStatus", "isBusy", false)
    end
end

-- Hack Security Failed
function ThermiteFailed()
    QBCore.Functions.Notify("You failed to hack the security system!", "error")
    TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
    TriggerServerEvent("qb-ifruitstore:server:SetSecurityStatus", "isBusy", false)

    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    local coords = GetEntityCoords(PlayerPedId())
    local randTime = math.random(10000,15000)
    CreateFire(coords, randTime)
end

-- NUI

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

-- RegisterNUICallback('thermitefailed', function()
--     PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
--     TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isBusy", false)
--     TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
--     TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["thermite"], "remove")
--     local coords = GetEntityCoords(PlayerPedId())
--     local randTime = math.random(10000, 15000)
--     CreateFire(coords, randTime)

--     TriggerServerEvent('qb-ifruitstore:server:PoliceAlertMessage', 'People try to steal items at the iFruit Store', coords, true)
-- end)

-- RegisterNUICallback('thermitesuccess', function()
--     QBCore.Functions.Notify("The fuses are broken", "success")
--     TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
--     local pos = GetEntityCoords(PlayerPedId())
--     if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 1.0 then
--         TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isDone", true)
--         TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isBusy", false)
--     end
-- end)

RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)

-- Events

RegisterNetEvent('SafeCracker:EndMinigame', function(won)
    if usingSafe then
        if won then
            if not Config.Locations["safe"].isDone then
                SetNuiFocus(false, false)
                TriggerServerEvent("qb-ifruitstore:server:SafeReward")
                TriggerServerEvent("qb-ifruitstore:server:SetSafeStatus", "isBusy", false)
                TriggerServerEvent("qb-ifruitstore:server:SetSafeStatus", "isDone", false)
                takeAnim()
            end
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("qb-ifruitstore:server:LoadLocationList")
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('qb-ifruitstore:client:LoadList', function(list)
    Config.Locations = list
end)

-- Start Thermite fire animation / When Thermite Minigame is successful
RegisterNetEvent("qb-ifruitstore:client:SetThermiteCharge", function (method)
    local ptfx
    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(1)
    end
    ptfx = vector3(157.81 + 0.25, -224.63, 59.60)
    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(5000)
    StopParticleFxLooped(effect, 0)
end)

-- Start fire animation for Thermite usage / When Thermite Minigame is unsuccessful
RegisterNetEvent("qb-ifruitstore:client:StartThermiteFire", function (coords, maxChildren, isGasFire)
    if #(vector3(coords.x, coords.y, coords.z) - GetEntityCoords(PlayerPedId())) < 100 then
        local pos = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        }
        pos.z = pos.z - 0.9
        local fire = StartScriptFire(pos.x, pos.y, pos.z, maxChildren, isGasFire)
        currentFires[#currentFires+1] = fire
    end
end)

-- Stop fire animation
RegisterNetEvent("qb-ifruitstore:client:StopThermiteFire", function ()
    for _, v in ipairs(currentFires) do
        RemoveScriptFire(v)
    end
end)

-- Use Thermite on The Security System on the roof
RegisterNetEvent('thermite:UseThermite', function()
    if QBCore ~= nil and LocalPlayer.state["isLoggedIn"] then
        local pos = GetEntityCoords(PlayerPedId())
        if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y, Config.Locations["thermite"].z)) < 1.0 then
            -- Check if enough cops are online
            if CurrentCops >= Config.RequiredCops then
                if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                    TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                end
                QBCore.Functions.TriggerCallback("qb-ifruitstore:callback:Cooldown", function(isCooldown)
                    if not isCooldown then
                        QBCore.Functions.TriggerCallback("QBCore:HasItem", function(hasItem)
                            if hasItem then
                                TriggerEvent("inventory:client:requiredItems", requiredItems, false)
                                TriggerServerEvent("qb-ifruitstore:server:SetSecurityStatus", "isBusy", true)
                                exports["memorygame"]:thermiteminigame(Config.CorrectBlocks, Config.IncorrectBlocks, Config.TimeToShow, Config.TimeToLose, function ()
                                    -- Success
                                    ThermiteAnimation()
                                    ThermiteSuccess()
                                    PoliceAlertMessage(POWEROUTAGE)
                                end, function ()
                                    -- Failed
                                    ThermiteFailed()
                                    PoliceAlertMessage(POWERBOXEXPLOSION)
                                end)
                            else
                                QBCore.Functions.Notify("You don't have the correct equipment!", "error")
                            end
                        end, "thermite")
                    else
                        QBCore.Functions.Notify("This has just been hit, you'll have to wait!", "error")
                    end
                end)
            else
                QBCore.Functions.Notify("Not enough police online, at least (".. Config.RequiredCops ..") required!", "error")
            end
        end
    end
end)

-- RegisterNetEvent('thermite:UseThermite', function()
--     local pos = GetEntityCoords(PlayerPedId())
--     if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 1.0 then
--         if CurrentCops >= 0 then
--             local pos = GetEntityCoords(PlayerPedId())
--             if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
--                 TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
--             end
--             if requiredItemsShowed then
--                 requiredItems = {
--                     [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
--                 }
--                 requiredItemsShowed = false
--                 TriggerEvent('inventory:client:requiredItems', requiredItems, false)
--                 TriggerServerEvent("qb-ifruitstore:server:SetThermiteStatus", "isBusy", true)
--                 SetNuiFocus(true, true)
--                 SendNUIMessage({
--                     action = "openThermite",
--                     amount = math.random(5, 6),
--                 })
--             end
--         else
--             QBCore.Functions.Notify("Not enough police", "error")
--         end
--     end
-- end)

RegisterNetEvent('qb-ifruitstore:client:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
end)

RegisterNetEvent('qb-ifruitstore:client:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
end)

-- Register Security Status
RegisterNetEvent("qb-ifruitstore:client:SetSecurityStatus", function (stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
end)

-- RegisterNetEvent('qb-ifruitstore:client:PoliceAlertMessage', function(msg, coords, blip)
--     if blip then
--         PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
--         TriggerEvent("chatMessage", "911-Report", "error", msg)
--         local transG = 100
--         local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0)
--         SetBlipSprite(blip, 9)
--         SetBlipColour(blip, 1)
--         SetBlipAlpha(blip, transG)
--         SetBlipAsShortRange(blip, false)
--         BeginTextCommandSetBlipName('STRING')
--         AddTextComponentString("911 - Suspicious situation in the iFruit Store")
--         EndTextCommandSetBlipName(blip)
--         while transG ~= 0 do
--             Wait(180 * 4)
--             transG = transG - 1
--             SetBlipAlpha(blip, transG)
--             if transG == 0 then
--                 SetBlipSprite(blip, 2)
--                 RemoveBlip(blip)
--                 return
--             end
--         end
--     else
--         if not robberyAlert then
--             PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
--             TriggerEvent("chatMessage", "911-Report", "error", msg)
--             robberyAlert = true
--         end
--     end
-- end)

-- RegisterNetEvent('qb-ifruitstore:client:robberyCall', function(streetLabel, coords)
--     if PlayerJob.name == "police" then

--         PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
--         TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
--             timeOut = 10000,
--             alertTitle = "iFruitStore robbery attempt",
--             coords = {
--                 x = coords.x,
--                 y = coords.y,
--                 z = coords.z,
--             },
--             details = {
--                 [1] = {
--                     icon = '<i class="fas fa-university"></i>',
--                     detail = "iFruit Store",
--                 },
--                 [2] = {
--                     icon = '<i class="fas fa-globe-europe"></i>',
--                     detail = streetLabel,
--                 },
--             },
--             callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
--         })

--         local transG = 250
--         local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
--         SetBlipSprite(blip, 487)
--         SetBlipColour(blip, 4)
--         SetBlipDisplay(blip, 4)
--         SetBlipAlpha(blip, transG)
--         SetBlipScale(blip, 1.2)
--         SetBlipFlashes(blip, true)
--         BeginTextCommandSetBlipName('STRING')
--         AddTextComponentString("10-90: iFruitStore Robbery")
--         EndTextCommandSetBlipName(blip)
--         while transG ~= 0 do
--             Wait(180 * 4)
--             transG = transG - 1
--             SetBlipAlpha(blip, transG)
--             if transG == 0 then
--                 SetBlipSprite(blip, 2)
--                 RemoveBlip(blip)
--                 return
--             end
--         end
--     end
-- end)

-- Thread

CreateThread(function()
    while true do
        Wait(1000 * 45 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        local inRange = false
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 10.0 then
                inRange = true
                if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 3.0 and not Config.Locations["thermite"].isDone then
                    DrawMarker(2, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.1, 255, 255, 255, 100, 0, 0, 0, 1, 0, 0, 0)
                    if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 1.0 then
                        if not Config.Locations["thermite"].isDone then
                            if not requiredItemsShowed then
                                requiredItems = {
                                    [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                                }
                                requiredItemsShowed = true
                                TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                            end
                        end
                    end
                else
                    if requiredItemsShowed then
                        requiredItems = {
                            [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                        }
                        requiredItemsShowed = false
                        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                    end
                end
            elseif not inRange then
                Wait(3000)
            end
        else
            Wait(3000)
        end
    end
end)

CreateThread(function()
    local inRange = false
    while true do
        Wait(1)
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            for spot, location in pairs(Config.Locations["takeables"]) do
                local dist = #(pos - vector3(Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z))
                if dist < 1.0 then
                    inRange = true
                    if dist < 0.6 then
                        if not requiredItemsShowed2 then
                            requiredItems = {
                                [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
                            }
                            requiredItemsShowed2 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                        if not Config.Locations["takeables"][spot].isBusy and not Config.Locations["takeables"][spot].isDone then
                            DrawText3Ds(Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z, '~g~E~w~ To grab item')
                            if IsControlJustPressed(0, 38) then
                                if CurrentCops >= Config.RequiredCops then
                                    QBCore.Functions.TriggerCallback("QBCore:HasItem", function (hasItem)
                                        if hasItem then
                                            currentSpot = spot
                                            GrabItem(currentSpot)
                                        else
                                            QBCore.Functions.Notify("You are missing an advanced lockpick", "error")
                                        end
                                    end, "advancedlockpick")
                                else
                                    QBCore.Functions.Notify("Not enough police online, at least (".. Config.RequiredCops ..") required!", "error")
                                end
                            end
                        end
                    else
                        if requiredItemsShowed2 then
                            requiredItems = {
                                [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
                            }
                            requiredItemsShowed2 = false
                            TriggerEvent("inventory:client:requiredItems", requiredItems, false)
                        end
                    end
                end
            end
        end
    end
end)
