Framework = {
  name = "qb-core",
  resourceName = "qb-core",
  isNewVersion = true,
  frameworkObject = nil,
  getPlayer = nil,
  getPlayerByIdentifier = nil,
  getPlayerSource = nil,
  getPlayerIdentifier = nil,
  getPlayerFirstName = nil,
  getPlayerLastName = nil,
  getPlayerPropertyFromPlayerData = nil,
  createCallback = nil,
  createCommandQBCore = nil,
  createCommandESX = nil,
  addItem = nil,
  removeItem = nil,
  getItemsByName = nil,
  triggerCallback = nil,
  getPlayerData = nil,
  getPlayerIdentifier_c = nil,
  getPlayerJob_c = nil,
  getPlayerGang_c = nil,
  isPlayerDown = nil
}

Framework.__index = Framework

-- Initialize framework methods based on framework type
local function initializeFramework(self)
  if self.name == "qb-core" then
      self.frameworkObject = exports[self.resourceName]:GetCoreObject()
      
      self.getPlayer = function(source)
          return self.frameworkObject.Functions.GetPlayer(source)
      end
      
      self.getPlayerByIdentifier = function(citizenid)
          return self.frameworkObject.Functions.GetPlayerByCitizenId(citizenid)
      end
      
      self.getPlayerIdentifier = function(source)
          local player = self.getPlayer(source)
          if player then
              return player.PlayerData.citizenid
          elseif source then
              print("Unable to retrieve player with source " .. (source or "undefined"))
          end
      end
      
      self.getPlayerSource = function(player)
          return player.PlayerData.source
      end
      
      self.getPlayerFirstName = function(player)
          return player.PlayerData.charinfo.firstname or player.getName()
      end
      
      self.getPlayerLastName = function(player)
          return player.PlayerData.charinfo.lastname or player.getName()
      end
      
      self.getPlayerPropertyFromPlayerData = function(player, property)
          if type(property) ~= "string" then
              property = tostring(property)
          end
          return player.PlayerData[property]
      end
      
      self.createCallback = function(name, cb)
          self.frameworkObject.Functions.CreateCallback(name, cb)
      end
      
      self.createCommandQBCore = function(...)
          return self.frameworkObject.Commands.Add(...)
      end
      
      self.getItemsByName = function(player, itemName)
          return player.Functions.GetItemsByName(itemName)
      end
      
      self.addItem = function(source, item, amount)
          return self.frameworkObject.Functions.AddItem(source, item, amount)
      end
      
      self.removeItem = function(source, item, amount)
          return self.frameworkObject.Functions.RemoveItem(source, item, amount)
      end
      
      self.triggerCallback = function(name, source, ...)
          self.frameworkObject.Functions.TriggerCallback(name, source, ...)
      end
      
      self.getPlayerData = function()
          -- Implement if needed
      end
      
      self.getPlayerIdentifier_c = function(source)
          -- Implement if needed
      end
      
      self.getPlayerJob_c = function(source)
          local player = self.getPlayer(source)
          return player and player.PlayerData.job
      end
      
      self.getPlayerGang_c = function(source)
          local player = self.getPlayer(source)
          return player and player.PlayerData.gang
      end
      
      self.isPlayerDown = function(source)
          -- Implement if needed
      end
  elseif self.name == "esx" then
      if self.isNewVersion then
          self.frameworkObject = exports[self.resourceName]:getSharedObject()
      else
          TriggerEvent("esx:getSharedObject", function(obj) self.frameworkObject = obj end)
      end
      -- Implement ESX-specific methods if needed
  else
      print("Framework not handled: " .. self.name)
  end
  return self
end

function Framework.New(frameworkType, resourceName, isNewVersion)
  local self = setmetatable({}, Framework)
  self.name = frameworkType and string.lower(frameworkType) or "qb-core"
  -- Handle resourceName as string or table
  self.resourceName = type(resourceName) == "table" and resourceName.name or resourceName or "qb-core"
  self.isNewVersion = isNewVersion or true
  return initializeFramework(self)
end

function Framework:GetPlayer(source)
  return self.getPlayer(source)
end

function Framework:GetPlayerByIdentifier(citizenid)
  return self.getPlayerByIdentifier(citizenid)
end

function Framework:GetPlayerIdentifier(source)
  return self.getPlayerIdentifier(source)
end

function Framework:GetPlayerSource(player)
  return self.getPlayerSource(player)
end

function Framework:GetPlayerFirstName(player)
  return self.getPlayerFirstName(player)
end

function Framework:GetPlayerLastName(player)
  return self.getPlayerLastName(player)
end

function Framework:GetPlayerPropertyFromPlayerData(player, property)
  return self.getPlayerPropertyFromPlayerData(player, property)
end

function Framework:GetPlayerByCitizenId(citizenid)
  return self.getPlayerByIdentifier(citizenid)
end

function Framework:CreateCommandQBCore(...)
  return self.createCommandQBCore(...)
end

function Framework:CreateCommandESX(...)
  return self.createCommandESX(...)
end

function Framework:CreateCallback(name, cb)
  return self.createCallback(name, cb)
end

function Framework:AddItem(source, item, amount)
  return self.addItem(source, item, amount)
end

function Framework:RemoveItem(source, item, amount)
  return self.removeItem(source, item, amount)
end

function Framework:GetItemsByName(source, itemName)
  return self.getItemsByName(source, itemName)
end

function Framework:TriggerCallback(name, source, ...)
  return self.triggerCallback(name, source, ...)
end

function Framework:GetPlayerData()
  return self.getPlayerData()
end

function Framework:GetPlayerIdentifier_c(source)
  return self.getPlayerIdentifier_c(source)
end

function Framework:GetPlayerJob_c(source)
  return self.getPlayerJob_c(source)
end

function Framework:GetPlayerGang_c(source)
  return self.getPlayerGang_c(source)
end

function Framework:IsPlayerDown(source)
  return self.isPlayerDown(source)
end