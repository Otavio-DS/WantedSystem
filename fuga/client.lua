local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local cFG = module("elite_wanted", "fuga")
local loc =  math.random(1,cFG.pontos)

local process = false
local preso = false 
 
cnFP = Tunnel.getInterface("elite_fuga")

RegisterNUICallback("ButtonClick", function(data, cb)
	if data.action == "fecharFliper" then
        jogando = false  
        SetNuiFocus(false, false)
        SendNUIMessage({type = 'fecharFliper'})
        ClearPedTasks(PlayerPedId())
    end
end)

Citizen.CreateThread(function()	
	while true do
		local skips = 1000
		local tempoAnimacao = cFG.tempoAnimacao
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(cFG.iniciar[loc].x , cFG.iniciar[loc].y, cFG.iniciar[loc].z)
		local distance = GetDistanceBetweenCoords(cFG.iniciar[loc].x, cFG.iniciar[loc].y,cdz,x,y,z,true)
		if distance <= cFG.distanceBlipProcura then
			skips = 1
				cFG.DrawText3DProcure(cFG.iniciar[loc].x, cFG.iniciar[loc].y, cFG.iniciar[loc].z)
				cFG.DrawMarkerFuga(cFG.iniciar[loc].x, cFG.iniciar[loc].y, cFG.iniciar[loc].z)
			if distance <= 1.8 then
				-- print('Entra?')
				if IsControlJustPressed(0,38) then
					-- print('Entra?')
					-- print(cnFP.checkPresidiario())
					if cnFP.checkPresidiario() then
						if not process then
							TriggerEvent('cancelando',true)
							local source = source
							-- vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
							cFG.startanimProcure()
							process = true
							cnFP.checkprogress()
							FreezeEntityPosition(ped,true)
							SetTimeout(cFG.tempoAnimacao,function()
								Citizen.Wait(tempoAnimacao)
								DoScreenFadeIn(tempoAnimacao)
								-- vRP._stopAnim(false)
								cFG.stopanimProcure()
								process = false
								TriggerEvent('cancelando',false)
								FreezeEntityPosition(ped,false)
								if cFG.percent >=  math.random(1,100) then
									cnFP.itemEncontrado()
									if cFG.DiminuirTempo then
										TriggerServerEvent("ds:downSentence")
									end
								else 
									cnFP.nadaEncontrado()
									if cFG.DiminuirTempo then
										TriggerServerEvent("ds:downSentence")
									end
								end 
								loc =  math.random(1,cFG.pontos)
							end)
						end
					end
				end
			end
		end
		Citizen.Wait(skips)
	end
end)

Citizen.CreateThread(function()	
	while true do
		local skips = 1000
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		local bowz,cdz = GetGroundZFor_3dCoord(cFG.fuga[1].x , cFG.fuga[1].y, cFG.fuga[1].z)
		local distance = GetDistanceBetweenCoords(cFG.fuga[1].x, cFG.fuga[1].y,cdz,x,y,z,true)
		if distance <= cFG.distanceBlipFuga then		    
			skips = 1
			cFG.DrawMarkerFuga(cFG.fuga[1].x, cFG.fuga[1].y, cFG.fuga[1].z)
			cFG.DrawText3DFuga(cFG.fuga[1].x, cFG.fuga[1].y, cFG.fuga[1].z)
			if distance <= 1.8 then
				if IsControlJustPressed(0,38) then	
					if cnFP.checkPresidiario() and cnFP.validaItem() then
						local source = source
						-- vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
						cFG.startanimProcure()
						SetNuiFocus(true,true)
						SendNUIMessage({action = "abrindo"})
					end
				end
			end
		end
		Citizen.Wait(skips)
	end
end)

RegisterNUICallback("ButtonClick", function( data, res) 
	if data.action == "quebrou" then 
	  SetNuiFocus(false,false)
	  ClearPedTasks( PlayerPedId());
	end 
 end)
   
 RegisterNUICallback("succeed", function( data, res) 
	SetNuiFocus(false,false)
	local source = source
	-- vRP._stopAnim(false)
	cFG.stopanimProcure()
	if cFG.AvisarPolicia then
	   local ativa = cnFP.chamouPoliciaFuga()
	end
	cnFP.fuga()
 end)
   
 RegisterNUICallback("failed", function( data, res) 
	SetNuiFocus(false,false)
	local source = source
	-- vRP._stopAnim(false)
	cFG.stopanimProcure()
	cnFP.presoTravado()
 end)
