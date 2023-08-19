local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local cFG = module("elite_wanted", "fuga") 
 
-----------------------------------------------------------------------------------------------------------------------------------------
-- USE PARA CONFIGURAR DE ACORDO COM SUA BASE
-----------------------------------------------------------------------------------------------------------------------------------------

getUserId = function(source)
    return vRP.getUserId(source)
end

getUserIdentity = function(user_id)
    return vRP.getUserIdentity(user_id)
end

getUserNomeCompleto = function(user_id)
    local identity = getUserIdentity(user_id)
    local name = identity.name.." "..identity.firstname
    return name
end

hasPermission = function(user_id, permission)
    return vRP.hasPermission(user_id, permission)
end

getUsersByPermission = function(user_id, permission)
    return vRP.getUsersByPermission(user_id, permission)
end

prompt = function(title,default_text)
    return vRP.prompt(title,default_text)
end

getSData = function(key, cbr)
    return vRP.getSData(key, cbr)
end

getUData = function(user_id, key, cbr)
    return vRP.getUData(user_id, key, cbr)
end

setUData = function(user_id, key, cbr)
    return vRP.setUData(user_id, key, cbr)
end

getPosition = function(source) -- Pegar a posição do player para o NotifyPush
    return vRPclient.getPosition(source)
end

tryGetInventoryItem = function(user_id,idname,amount,notify,slot)
    return vRP.tryGetInventoryItem(user_id,idname,amount,notify,slot)
end

getInventoryItemAmount = function(user_id,amount)
    return vRP.getInventoryItemAmount(user_id,amount)
end

giveInventoryItem = function(user_id,idname,amount,notify,slot)
    return vRP.giveInventoryItem(user_id,idname,amount,notify,slot)
end