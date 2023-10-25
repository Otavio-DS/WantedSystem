local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy") 
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local cFG = module("elite_wanted", "fuga")

cnFP = {}
Tunnel.bindInterface("elite_fuga",cnFP)

RegisterServerEvent("ds:downSentence") 
AddEventHandler("ds:downSentence",function()
	local source = source
	local user_id = getUserId(source)
	local value = getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
	if tempo >= 2 then
		setUData(parseInt(user_id),"vRP:prisao",json.encode(parseInt(tempo)-2))
		TriggerClientEvent("Notify", source, cFG.notify['aviso'],"Sua pena foi reduzida em <b>2 meses</b>, continue o trabalho.",cFG.timeNotify)
	else
		TriggerClientEvent("Notify", source, cFG.notify['aviso'],"Atingiu o limite da redução de pena, não precisa mais trabalhar.",cFG.timeNotify)
	end
end)


function cnFP.itemEncontrado()
    local source = source
    local user_id = getUserId(source)
    local value = getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
    if 1 == math.random(1, cFG.qtdItem) then
        giveInventoryItem(user_id,cFG.dropItem,1) 
        TriggerClientEvent("Notify",source,cFG.notify[cFG.notify['sucesso']],"Você encontrou "..cFG.dropItem,cFG.timeNotify)
    else 
        local item = math.random(1, cFG.qtdItem)
        giveInventoryItem(user_id,cFG.itemAux[item].item,1) 
        TriggerClientEvent("Notify",source,cFG.notify[cFG.notify['sucesso']],"Você encontrou ".. cFG.itemAux[item].nome,cFG.timeNotify)
    end 
end 

function cnFP.checkprogress()
    TriggerClientEvent("progress", source, 10000, "PROCURANDO")
end

function cnFP.checkPresidiario()
    local source = source
	local user_id = getUserId(source)
	local value = getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
	if parseInt(tempo) >= 1 then
        return true
    else
        TriggerClientEvent("Notify",source,cFG.notify['negado'],"Você não está preso")
        return false
    end
end

function cnFP.nadaEncontrado()
    TriggerClientEvent("Notify",source,cFG.notify['negado'],"Nada foi encontrado")
end 

function cnFP.presoTravado()
    TriggerClientEvent("Notify",source,cFG.notify['negado'],"A chave quebrou")
end 

function cnFP.fuga() -- Função que faz a fuga do player
    local source = source
    local user_id = getUserId(source)
    local player = vRP.getUserSource(parseInt(user_id))
    if user_id then
        TriggerClientEvent('prisioneiro',source,false) -- Seta o prisioneiro como false
        setUData(user_id, "vRP:prisao",json.encode(parseInt(-100))) -- Tira o tempo de cadeia do banco de dados
        if cFG.foragido then -- Define se vai setar como foragido ou não
            TriggerClientEvent('prisioneiro',source,false)
            setUData(user_id,"DosSantos:Procurado",99999999999) -- Seta o tempo de procurado
            TriggerClientEvent('DS:IniciouProcura',source,true) -- Puxa o evento para setar procurado
            setUData(user_id, "vRP:prisao",json.encode(parseInt(-100))) 
            TriggerClientEvent('RemovePrision',source)
        end     
        if cFG.useMdt then
            vRP.execute('creative/set_prison',{ user_id = parseInt(user_id), prison = -100 }) 
        end
        if cFG.AvisarPolicia then
            TriggerClientEvent('ds:ChecarProcurados',source) -- Checa os procurado
        end
        TriggerClientEvent('Notify',source, cFG.notify['sucesso'], 'Aguarde para ser levado até o local',15000 )
        Citizen.Wait(5000)
        vRPclient.teleport(player, cFG.fugaTeleport[1].x , cFG.fugaTeleport[1].y, cFG.fugaTeleport[1].z)
    end
end

function cnFP.validaItem()
    local existeItem = false
    local source = source
    local user_id = getUserId(source)
    if tryGetInventoryItem(user_id,cFG.dropItem,1) then 
        existeItem = true
    else 
        TriggerClientEvent("Notify",source,cFG.notify['negado'],"Você não possui uma chave")
    end 
    return existeItem
end 

function cnFP.chamouPoliciaFuga()
    local policia = getUsersByPermission(cFG.policiaPerm)
    local x, y, z = getPosition(source)
    for k, v in pairs(policia) do
        local player = vRP.getUserSource(parseInt(v))
        if player then
            local data = { x = x, y = y, z = z, title = cFG.titulo, code = cFG.codigo, veh = cFG.textonotify }
            TriggerClientEvent('NotifyPush',player,data)
        end
    end
end