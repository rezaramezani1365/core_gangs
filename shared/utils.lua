-- Set inventory flags
Config.UsingCoreInventory = Config.UseInventory == "core_inventory"
Config.UsingQBInventory = Config.UseInventory == "qb-inventory"
Config.UsingQSInventory = Config.UseInventory == "qs-inventory"
Config.UsingOxInventory = Config.UseInventory == "ox_inventory"
Config.UsingCodeMInventory = Config.UseInventory == "codem-inventory"
Config.UsingTgiannInventory = Config.UseInventory == "tgiann-inventory"
Config.UsingCustomInventory = Config.UseInventory == "custom"

-- Set framework flags
Config.UsingESX = Config.Framework == "esx"
Config.UsingQBCore = Config.Framework == "qb-core"

-- Deep comparison of two tables
function table.matches(a, b)
    if type(a) ~= type(b) then
        return false
    end

    if type(a) ~= "table" then
        return a == b
    end

    for k, v in pairs(a) do
        if b[k] == nil then
            return false
        end
        if not table.matches(v, b[k]) then
            return false
        end
    end

    for k, v in pairs(b) do
        if a[k] == nil then
            return false
        end
        if not table.matches(a[k], v) then
            return false
        end
    end

    return true
end