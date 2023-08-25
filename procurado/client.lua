--------------------------------------------------------
-- connection
--------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
elite = Tunnel.getInterface("elite_procurado")
vSERVER = Tunnel.getInterface("elite_procurado")

RegisterNetEvent('Procurado:IniciouProcura')
AddEventHandler('Procurado:IniciouProcura', function(time)
    TriggerEvent('wanted:startWanted',99999999999)
end)

RegisterNetEvent('tirandoprocurado')
AddEventHandler('tirandoprocurado', function()
    TriggerEvent('wanted:removeWanted')
end)
------------------------------------------------------------------------------------
-- variavery
------------------------------------------------------------------------------------
local wanted = false
local wantedSeconds = 0
------------------------------------------------------------------------------------
  -- startWanted
------------------------------------------------------------------------------------
RegisterNetEvent('wanted:startWanted')
AddEventHandler('wanted:startWanted', function(time)
    if wantedSeconds == 0 then
        juia = tonumber(time) 
        wantedSeconds = juia
        wanted = true
        elite.addList()
        TriggerEvent('Notify', 'aviso', textovcestaprocurado)
    end
end)
------------------------------------------------------------------------------------
-- removeWanted
------------------------------------------------------------------------------------
RegisterNetEvent('wanted:removeWanted')
AddEventHandler('wanted:removeWanted', function(time)
    if wantedSeconds > 0 then
        TriggerEvent('Notify', 'sucesso', textonprocurado)
        wantedSeconds = 0
        wanted = false
    end
end)

-- Citizen.CreateThread(function()
--     while true do
--     local sleep = 1000
--     if wanted then
--         sleep = 100
--         vSERVER.chamouPolicia1() -- Faz a função de chaamar a polícia
--         if Avisar then -- If para decidir de o player vai ou não saber se a polícia foi chamada
--             TriggerEvent('Notify', 'aviso',textolocalizado)
--         end
--     end
--     Wait(sleep)
-- end)

------------------------------------------------------------------------------------
-- Verifica se está procurado
------------------------------------------------------------------------------------
RegisterNetEvent('Procurado:ChecarProcurados')
AddEventHandler('Procurado:ChecarProcurados', function()
    if wanted then
        vSERVER.chamouPolicia1() -- Faz a função de chaamar a polícia
        if Avisar then -- If para decidir de o player vai ou não saber se a polícia foi chamada
            TriggerEvent('Notify', 'aviso',textolocalizado)
        end
    end
end)
------------------------------------------------------------------------------------
-- Tentou Hacker o sistema
------------------------------------------------------------------------------------
-- RegisterNetEvent('Procurado:falhouHacker')
-- AddEventHandler('Procurado:falhouHacker', function()
--     if wanted then
--         if AvisarHack then -- If para chamar a polícia ou se falhar o hack
--             print('aqui?')
--             vSERVER.chamouPolicia2()
--             TriggerEvent('Notify', 'aviso',textolocalizado2)
--         end
--     end
-- end)
------------------------------------------------------------------------------------
-- Faz a verificação se está procurado de tempo em tempo
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if wanted then
            sleep = 5
            drawTxt(textoprocurado, 5, 0.925, 0.101, 0.40, 255, 255, 255, 10)
        end
        Wait(sleep)
    end
end)
------------------------------------------------------------------------------------
-- thread Cooldown
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if wanted then
            if wantedSeconds > 0 then
                wantedSeconds = wantedSeconds - 1
            elseif wantedSeconds == 0 then 
                TriggerEvent('Notify', 'sucesso', textonprocurado)
                wantedSeconds = 0
                wanted = false
            end
        end
        Wait(1000)
    end
end)
------------------------------------------------------------------------------------
-- thread Blip para tirar o hacker
------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
        -- Wait(idle)
        -- if not HasStreamedTextureDictLoaded("marker") then
		-- 	RequestStreamedTextureDict("marker", true)
		-- 	while not HasStreamedTextureDictLoaded("marker") do
		-- 		Wait(1) 
		-- 	end
        -- else
            local idle = 1000
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local x,y,z = table.unpack(GetEntityCoords(ped))
            for k,v in pairs(config.blipCoords) do
                local distance = #(pedCoords - v['coords'])
                if distance <= 3 then
                    idle = 5
                    -- DrawMarker(21, v['coords'].x, v['coords'].y, v['coords'].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255, 0, 0,100,0,0,0,1) 
                    config.DrawMarker(v['coords'].x, v['coords'].y, v['coords'].z)
                    if distance < 3 then
                        config.DrawText3D(v['coords'].x,v['coords'].y,v['coords'].z)
                        if IsControlJustPressed(0,config.tecla) then
                            if useTaskbar then
                                TriggerServerEvent("item_r_Procurado")
                            end 
                            if nTaskbar then
                                TriggerServerEvent("item_r_ProcuradoSimples")
                            end
                        end
                    end
                end
            end
        -- end
		Citizen.Wait(idle)
	end
end)
------------------------------------------------------------------------------------
-- functions
------------------------------------------------------------------------------------
function drawTxt(text, font, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end


DrawText3D = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
	-- local x,y,z = table.unpack(coords)
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
	local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 50)
end