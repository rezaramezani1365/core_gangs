-- Initialize framework
Framework = Framework.New(Config.Framework, Config.FrameworkResource, Config.NewFrameworkVersion)

-- Inventory integration for qb-core
if Config.Framework == "qb-core" then
    QBCore = exports[Config.FrameworkResource]:GetCoreObject()

    -- Register callback for adding items
    Framework:CreateCallback("core_gangs:server:addInventoryItem", function(source, cb, item, amount)
        local success = Framework:AddItem(source, item, amount)
        cb(success)
    end)

    -- Register callback for removing items
    Framework:CreateCallback("core_gangs:server:removeInventoryItem", function(source, cb, item, amount)
        local success = Framework:RemoveItem(source, item, amount)
        cb(success)
    end)

    -- Register callback for getting items
    Framework:CreateCallback("core_gangs:server:getInventoryItems", function(source, cb, itemName)
        local player = Framework:GetPlayer(source)
        local items = player and Framework:GetItemsByName(source, itemName) or {}
        cb(items)
    end)
elseif Config.Framework == "esx" then
    if Config.NewFrameworkVersion then
        ESX = exports[Config.FrameworkResource]:getSharedObject()
    else
        TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
    end
    -- Add ESX inventory integration here if needed
end