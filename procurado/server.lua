------------------------------------------------------------------------------------
-- connection
------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP") 
vRPclient = Tunnel.getInterface("vRP")
elite = {}
Tunnel.bindInterface("elite_procurado",elite)
-- elite = Tunnel.getInterface("elite_procurado")
------------------------------------------------------------------------------------
-- connect
------------------------------------------------------------------------------------

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterCommand('addprocurado',function(source,args,rawCommand)
	local user_id = getUserId(source)
    local identity = getUserIdentity(user_id)
	if hasPermission(user_id,config.addprocurado) then
		local crimes = prompt(source,"Crimes:","")
		if crimes == "" then
			return
		end
        local playerWanted = vRP.getUserSource(parseInt(args[1]))
        local PassaporteWanted = getUserId(playerWanted)
        local identityWanted = getUserIdentity(PassaporteWanted)
		if playerWanted then
			setUData(PassaporteWanted,"vRP:Procurado",99999999999)
            TriggerClientEvent('Procurado:IniciouProcura',playerWanted,true) 
            TriggerClientEvent("vrp_sound:source",playerWanted,'jaildoor',0.7)
            SendWebhookMessage(config.logaddprocurado,'```prolog\n---------------[Policial que executou a ação]--------------- \n\n[Passaporte]: ' .. user_id .. ' \n[Nome]: Nome ' ..getUserNomeCompleto(user_id)..'\n\n\n---------------[Cidadão na lista de procurados]--------------- \n[Passaporte]: ' .. PassaporteWanted .. ' \n[Nome]:' ..getUserNomeCompleto(PassaporteWanted)..' \n[Registro]: '..identityWanted.registration..' \n\n[Crimes Cometidos]: ' .. crimes .. '```')
            TriggerClientEvent('Notify',source, 'sucesso', 'Passaporte ' ..PassaporteWanted..',\n\n Nome: '..getUserNomeCompleto(PassaporteWanted)..', adicionado a lista de procurados',15000)
        end
    end
end)

RegisterCommand('remprocurado',function(source,args,rawCommand)
	local user_id = getUserId(source)
    local identity = getUserIdentity(user_id)
	if hasPermission(user_id,config.remprocurado) then
		local motivo = prompt(source,"Motivo para retirada:","")
		if motivo == "" then
			return
		end
        local playerWanted = vRP.getUserSource(parseInt(args[1]))
        local PassaporteWanted = getUserId(playerWanted)
        local identityWanted = getUserIdentity(PassaporteWanted)
		if playerWanted then
			setUData(PassaporteWanted,"vRP:Procurado",0)
            TriggerClientEvent('tirandoprocurado',playerWanted,true)
            SendWebhookMessage(config.logremprocurado,'```prolog\n---------------[Quem removeu da lista de procurados]--------------- \n\n[Passaporte]: ' .. user_id .. ' \n[Nome]: Nome ' ..getUserNomeCompleto(user_id)..'\n\n---------------[Cidadão removido da lista de procurados]--------------- \n[Passaporte]: ' .. PassaporteWanted .. ' \n[Nome]:' ..getUserNomeCompleto(PassaporteWanted)..' \n[Registro]: '..identityWanted.registration..' \n\n[Motivo da remoção]: ' .. motivo .. '```')
            TriggerClientEvent('Notify',source, 'sucesso', 'Passaporte ' ..PassaporteWanted..',\n\n Nome: '..getUserNomeCompleto(playerWanted)..', não está mais procurado',15000)
        end
    end
end)

RegisterCommand('procurado',function(source,args,rawCommand)
	local user_id = getUserId(source)
    local identity = getUserIdentity(user_id)
    print(hasPermission(user_id,config.checkprocurado))
	if hasPermission(user_id,config.checkprocurado) then
        local motivo = prompt(source,"Motivo da pesquisa:","")
		if motivo == "" then
			return
		end
        local playerWanted = vRP.getUserSource(parseInt(args[1]))
        local PassaporteWanted = getUserId(playerWanted)
        local identityWanted = getUserIdentity(PassaporteWanted)
        local resp4 = getUData(parseInt(PassaporteWanted),"vRP:Procurado")
        local procuradop = json.decode(resp4) or 0

		if procuradop > 0 then
			procuradop = 'Sim'
		else
			procuradop = 'Não'
		end

        SendWebhookMessage(config.logconsultaprocurado,'```prolog\n---------------[Policial que fez a pesquisa]--------------- \n\n[Passaporte]: ' .. user_id .. ' \n[Nome]: Nome ' ..getUserNomeCompleto(user_id)..'\n\n\n---------------[Cidadão que foi pesquisado]--------------- \n[Passaporte]: ' .. PassaporteWanted .. ' \n[Nome]:' ..getUserNomeCompleto(PassaporteWanted)..' \n[Registro]: '..identityWanted.registration..' \n\n[Motivo da procura]: ' .. motivo .. ' \n[Procurado?]: '..procuradop..'```')
		if playerWanted then
            local value = getUData(parseInt(user_id),"vRP:Procurado")
            local tempo = json.decode(value) or 0
            if tempo == 0 then
                TriggerClientEvent('Notify', source, 'aviso', 'Passaporte ' ..PassaporteWanted..',\n\n de nome '..getUserNomeCompleto(PassaporteWanted)..' , não consta na lista de procurados',20000)
                return
            end
            
            if tempo > 0 then
                TriggerClientEvent('Notify', source, 'aviso', 'Passaporte ' ..PassaporteWanted..',\n\n de nome '..getUserNomeCompleto(PassaporteWanted)..', consta na lista de procurados',20000)
                TriggerClientEvent('Procurado:IniciouProcura',playerWanted,true)
            end
        end
    end
end)

RegisterServerEvent('Procurado:rProcurado') -- Evento para usar o item remover o procurado com taskbar e em lugar específico
AddEventHandler('Procurado:rProcurado',function()
    local source = source
    local user_id = getUserId(source)
    if user_id then
        TriggerClientEvent('tirandoprocurado',source,true)
        TriggerEvent('remprocuradoevento',source, true)
    end
end)

RegisterServerEvent('remprocuradoevento')
AddEventHandler('remprocuradoevento',function(source,user_id)
    local source = source
    local user_id = getUserId(source)
    if user_id then
        setUData(user_id,"vRP:Procurado",0)
    end
end)


RegisterServerEvent('item_r_Procurado') -- Evento para usar o item remover o procurado com taskbar e em lugar específico
AddEventHandler('item_r_Procurado',function()
    local source = source
    local user_id = getUserId(source)
    local identity = getUserIdentity(user_id)
    local x, y, z = getPosition(source)
    if user_id then
        if getInventoryItemAmount(user_id, config.item) >= config.amount then
            if tryGetInventoryItem(user_id, config.item, config.amount) then
                local taskbarresult = exports['c2n_taskbar']:getTaskBar(source,"facil","Ocenside")
                if taskbarresult then
                    TriggerClientEvent('cancelando', source, true)
                    config.startanim(source)
                    TriggerClientEvent("progress", source, 15000, "HACKEANDO")
                    SetTimeout(15000, function()
                        TriggerClientEvent('tirandoprocurado',source,true)
                        TriggerEvent('remprocuradoevento',source, true)
                        -- setUData(user_id,"vRP:Procurado",0)
                        TriggerClientEvent("vrp_sound:source", source, 'finish', 0.5)
                        TriggerClientEvent('cancelando', source, false)
                        config.stopanim(source)
                        SendWebhookMessage(config.hackersucess,"```prolog\n[ID]: "..user_id.." "..getUserNomeCompleto(user_id).." \n[LOCALIZAÇÃO] ".. x.. ", "..y..", "..z.." \nHACKEOU O SISTEMA DA POLÍCIA E TIROU SEU NOME DA LISTA DE PROCURADOS  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                    end)
                else
                    local policia = getUsersByPermission(config.policiapermissao)
                    local x, y, z = getPosition(source)
                    for k, v in pairs(policia) do
                        local player = vRP.getUserSource(parseInt(v))
                        if player then
                            local data = { x = x, y = y, z = z, title = config.titulo2, code = config.codigo2, veh = config.textonotify2 }
                            TriggerClientEvent('NotifyPush',player,data)
                        end
                    end
                    SendWebhookMessage(config.hackerfail,"```prolog\n[ID]: "..user_id.." "..getUserNomeCompleto(user_id).." \n[LOCALIZAÇÃO] ".. x.. ", "..y..", "..z.." \nFALHOU AO HACKEAR O SISTEMA DA POLÍCIA"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                    TriggerClientEvent("Notify",source,"negado","Você falhou ao tentar hacker o sistema da polícia",5000)
                    TriggerClientEvent('Notify',source, 'aviso',textolocalizado2,9000)
                end
            end 
        else
            TriggerClientEvent("Notify",source,"negado","Item insuficiente.",5000)
        end
    end
end)

RegisterServerEvent('item_r_ProcuradoSimples') -- Evento para usar o item remover o procurado sem taskbar e em lugar específico
AddEventHandler('item_r_ProcuradoSimples',function()
    local source = source
    local user_id = getUserId(source)
    local identity = getUserIdentity(user_id)
    if user_id then
        if getInventoryItemAmount(user_id, config.item) >= config.amount then
            if tryGetInventoryItem(user_id, config.item, config.amount) then
                TriggerClientEvent('cancelando', source, true)
                config.startanim(source)
                TriggerClientEvent("progress", source, 15000, "HACKEANDO")
                SetTimeout(15000, function()
                    TriggerClientEvent('tirandoprocurado',user_id,true)
                    setUData(user_id,"vRP:Procurado",0)
                    TriggerClientEvent("vrp_sound:source", source, 'finish', 0.5)
                    TriggerClientEvent('cancelando', source, false)
                    config.stopanim(source)
                    SendWebhookMessage(config.hackersucess,"```prolog\n[ID]: "..user_id.." "..getUserNomeCompleto(user_id).." \n[LOCALIZAÇÃO] ".. x.. ", "..y..", "..z.." \nHACKEOU O SISTEMA DA POLÍCIA E TIROU SEU NOME DA LISTA DE PROCURADOS  "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").."```")
                end)
            end
        else
            TriggerClientEvent("Notify",source,"negado","Item insuficiente.",5000)
        end 
    end
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    local playerWanted = vRP.getUserSource(parseInt(user_id))
    if playerWanted then
        SetTimeout(10000,function()
            local value = getUData(parseInt(user_id),"vRP:Procurado")
            local tempo = json.decode(value) or -1
        
            if tempo == -1 then
                return
            end
        
            if tempo > 0 then
                TriggerClientEvent('Procurado:IniciouProcura',playerWanted,true)
            end
        end)
    end
end)
------------------------------------------------------------------------------------
------ [ Função para chamar a polícia ] --------------------------------------------
------------------------------------------------------------------------------------

function elite.chamouPolicia1()
    local policia = getUsersByPermission(config.policiapermissao)
    local x, y, z = getPosition(source)
    for k, v in pairs(policia) do
        local player = vRP.getUserSource(parseInt(v))
        if player then
            local data = { x = x, y = y, z = z, title = config.titulo, code = config.codigo, veh = config.textonotify }
            TriggerClientEvent('NotifyPush',player,data)
        end
    end
end

function elite.chamouPolicia2() 
    local policia = getUsersByPermission(config.policiapermissao)
    local x, y, z = getPosition(source)
    for k, v in pairs(policia) do
        local player = vRP.getUserSource(parseInt(v))
        if player then
            local data = { x = x, y = y, z = z, title = config.titulo2, code = config.codigo2, veh = config.textonotify2 }
            TriggerClientEvent('NotifyPush',player,data)
        end
    end
end

-- AddEventHandler('onResourceStart', function(resourceName)
-- 	if (GetCurrentResourceName() ~= resourceName) then
-- 	  return
-- 	end
-- 	print(resourceName,'^2INICIADO^0')
-- 	Wait(10000)
-- 	print( "[+] ^2Autenticado^0 - Qualquer dúvida entre em contato com -> ^4dossantosrp.")
-- end)

-- AddEventHandler('onResourceStop', function(resourceName)
-- 	if (GetCurrentResourceName() ~= resourceName) then
-- 	  return
-- 	end
-- 	print(resourceName,'^1PARADO^0')
-- end)