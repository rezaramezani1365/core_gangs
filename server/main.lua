-- Initialize framework
Framework = Framework.New(Config.Framework, Config.FrameworkResource, Config.NewFrameworkVersion)

if Config.Framework == "qb-core" then
    QBCore = exports[Config.FrameworkResource]:GetCoreObject()
elseif Config.Framework == "esx" then
    if Config.NewFrameworkVersion then
        ESX = exports[Config.FrameworkResource]:getSharedObject()
    else
        TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
    end
end

-- Global variables
local currentZone = nil
local isInitialized = false
local isDebugMode = false
Zones = {}
Organizations = {}
Criminals = {}
Bounties = {}
Invitations = {}
Wars = {}
Participants = {}
ZoneCooldowns = {}
OrgCooldowns = {}
NPCS = {}

-- Get player's currency count
function GetPlayerCurrency(citizenid)
    local items = Framework.GetItemsByName(citizenid, Config.CurrencyName)
    local total = 0

    if items then
        if type(items) == "table" then
            if items.count or items.amount then
                total = (items.count or 0) + (items.amount or 0)
            else
                for _, item in pairs(items) do
                    total = total + (item.count or 0) + (item.amount or 0)
                end
            end
        end
    end

    return total
end

-- Remove currency from player
function RemovePlayerCurrency(citizenid, amount)
    local currentCurrency = GetPlayerCurrency(citizenid)
    if currentCurrency and amount <= currentCurrency then
        local success = Framework.RemoveItem(citizenid, Config.CurrencyName, amount)
        TriggerClientEvent("core_gangs:client:updateCurrency", Framework.GetPlayerSource(citizenid), GetPlayerCurrency(citizenid))
        return success
    end
    return false
end

-- Add currency to player
function AddPlayerCurrency(citizenid, amount)
    local success = Framework.AddItem(citizenid, Config.CurrencyName, amount)
    TriggerClientEvent("core_gangs:client:updateCurrency", Framework.GetPlayerSource(citizenid), GetPlayerCurrency(citizenid))
    return success
end

-- Add multiple items to player with random amounts
function AddRandomItems(citizenid, items)
    local inventoryFull = false
    for item, range in pairs(items) do
        if type(range) == "table" and #range == 2 then
            math.randomseed(os.time())
            local amount = math.random(range[1], range[2])
            if amount > 0 then
                local success = Framework.AddItem(citizenid, item, tonumber(amount))
                if not success then
                    inventoryFull = true
                end
            end
        end
    end
    return not inventoryFull
end

-- Format notification message
function FormatNotification(notification, source, targetData)
    if not notification then
        print("[Core Gangs]^1 Can't send log, data retrieve are empty ^7")
        return nil
    end

    local placeholders = {
        ["{{sourceName}}"] = Framework.GetPlayerFullName(source) or "",
        ["{{sourceCitizenid}}"] = Framework.GetPlayerIdentifier(source) or "",
        ["{{sourceSource}}"] = tostring(source),
        ["{{targetName}}"] = targetData.targetName or (Framework.GetPlayerFirstName(targetData.targetSource) .. " " .. Framework.GetPlayerLastName(targetData.targetSource)),
        ["{{newOwnerIdentifier}}"] = targetData.targetIdentifier or "",
        ["{{targetCitizenid}}"] = targetData.targetIdentifier or "",
        ["{{targetCriminalName}}"] = targetData.targetCriminalName or (Criminals[targetData.targetIdentifier] and Criminals[targetData.targetIdentifier].name or ""),
        ["{{targetSource}}"] = targetData.targetSource or "offline",
        ["{{targetIdentifier}}"] = targetData.targetIdentifier or ""
    }

    local formatted = {}
    for key, value in pairs(notification) do
        formatted[key] = value
    end

    for placeholder, value in pairs(placeholders) do
        if formatted.Title and string.find(formatted.Title, placeholder) then
            formatted.Title = string.gsub(formatted.Title, placeholder, value)
        end
        if formatted.Text and string.find(formatted.Text, placeholder) then
            formatted.Text = string.gsub(formatted.Text, placeholder, value)
        end
    end

    return formatted
end

-- Send Discord log
function SendDiscordLog(data)
    if not data then
        print("[Core Gangs]^1 Can't send log, data retrieve are empty ^7")
        return
    end

    local embed = {
        title = "**" .. data.Title .. "**\n",
        color = data.DiscordMsgColor or ConfigDiscord.DiscordMsgColor,
        footer = { text = os.date("%c") },
        description = data.Text,
        author = {
            name = data.DiscordUsername or ConfigDiscord.DiscordUsername,
            icon_url = data.DiscordAvatar or ConfigDiscord.DiscordAvatar
        }
    }

    PerformHttpRequest(data.ChannelWebHook, function() end, "POST", json.encode({
        username = data.DiscordUsername or ConfigDiscord.DiscordUsername,
        embeds = { embed }
    }), { ["Content-Type"] = "application/json" })
end

-- Check and send Discord log
function CheckDiscordLog(logType, source, targetData)
    if ConfigDiscord and ConfigDiscord.DiscordLogEnable and ConfigDiscord.DiscordLogs[logType] and ConfigDiscord.DiscordLogs[logType].Enable then
        local formatted = FormatNotification(ConfigDiscord.DiscordLogs[logType], source, targetData)
        if formatted then
            SendDiscordLog(formatted)
        end
    elseif not ConfigDiscord.DiscordLogs[logType] then
        print("[Core Gangs]^1 Can't send log, can't find type " .. logType .. " in the config file ^7")
    end
end

-- Command to trigger zone action (tz)
RegisterCommand("tz", function(source, args)
    local citizenid = tonumber(args[1])
    TriggerZoneAction(citizenid)
end)

-- Placeholder for TriggerZoneAction
function TriggerZoneAction(citizenid)
    print("[Core Gangs] Triggering zone action for citizenid: " .. citizenid)
    -- Add actual logic here or ensure it is defined in another file
end