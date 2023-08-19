config = {}

config.distanceBlipProcura = 100.0 -- Aqui vc aumenta ou diminui a distância em que o blip poderá ser avistado (Procura de itens)
config.distanceBlipFuga = 100.0 -- Aqui vc aumenta ou diminui a distância em que o blip poderá ser avistado (Tentativa de fuga)

config.titulo = 'Um prisioneiro fugiu da penitenciária, vá até o local' -- Título da Notify
config.codigo = 'FUGA' -- Código na Notify

config.policiaPerm = 'policia.permissao'

config.percent = 99 -- Aqui é o percentual para se vai aparecer itens ou não
 
config.useMdt = true -- Caso você use o elite_mdt deixe true

config.DiminuirTempo = true -- Aqui você decide se a cada blip procurado diminui a pena do preso, ou não (true para sim, false para não)

config.AvisarPolicia = true -- Aqui você escolhe se quando o player fugir, vai avisar ou não a polícia

config.foragido = true -- Aqui valida se vai incluir o player como foragido true para sim e false para não (Apenas se você usa o elite_procurado)

config.tempoAnimacao = 5000 -- Aqui é o tempo da animação em cada blip de procura

config.dropItem = 'chave' -- Aqui é o item a ser dropado para poder fugir

config.timeNotify = 5000 -- 5 Segundos

config.notify = {
    ['aviso'] = 'aviso',
    ['negado'] = 'negado',
    ['sucesso'] = 'sucesso',
}
getPosition = function(source)
    return vRPclient.getPosition(source)
end

----------------------------------------------------------------------------------------------------------------------------
-------- [ CONFIGURAÇÃO DE ANIMAÇÃO ] --------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
config.startanimProcure = function(source)
    vRP._playAnim(false,{{"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}},true)
end

config.stopanimProcure = function(source)
    vRP._stopAnim(false)
end
-----d

config.fuga = { [1] = { ['x'] = 1661.89, ['y'] = 2487.34, ['z'] = 45.56 }} -- Local para iniciar a fuga 

config.fugaTeleport = { [1] = { ['x'] = 1534.94, ['y'] = 2588.98, ['z'] = 45.4 }} -- Onde o player vai aparecer após dar a fuga

config.pontos = 11 -- Aqui tem que colocar a quantidade de localizações que você colocou no config.iniciar 

config.iniciar = {	  -- Aqui coloca os pontos de procura

    [1] = { ['x'] = 1651.1, ['y'] =  2564.43, ['z'] = 45.57},
    [2] = { ['x'] = 1652.72, ['y'] = 2564.34, ['z'] = 45.57},
    [3] = { ['x'] = 1654.04, ['y'] = 2564.35, ['z'] = 45.57},
    [4] = { ['x'] = 1632.33, ['y'] = 2529.16, ['z'] = 45.57},
    [5] = { ['x'] = 1630.41, ['y'] = 2527.02, ['z'] = 45.57},
    [6] = { ['x'] = 1644.56, ['y'] = 2490.84, ['z'] = 45.57},
    [7] = { ['x'] = 1643.17, ['y'] = 2490.81, ['z'] = 45.57},
    [8] = { ['x'] = 1622.5, ['y'] = 2507.0, ['z'] = 45.57},
    [9] = { ['x'] = 1622.36, ['y'] = 2508.29, ['z'] = 45.57},
    [10] = { ['x'] = 1608.5, ['y'] = 2566.47, ['z'] = 45.57},
    [11] = { ['x'] = 1609.53,['y'] = 2567.5, ['z'] = 45.57}
    
}

config.qtdItem = 10 -- Quantos itens você colocou no config.itemAux

config.itemAux = { -- Aqui são os itens auxiliar 

    [1] = { ['item'] = 'agua', ['nome']='Água' },
    [2] = { ['item'] = 'xburguer', ['nome']='xBurguer'},
    [3] = { ['item'] = 'pao', ['nome']='Pão'},
    [4] = { ['item'] = 'lockpick', ['nome']='Lockpick'},
    [5] = { ['item'] = 'chave', ['nome']='Chave'},
    [6] = { ['item'] = 'bchocolate', ['nome']='Chocolate'},
    [7] = { ['item'] = 'maconha', ['nome']='Maconha'},
    [8] = { ['item'] = 'baseado', ['nome']='Baseado'},
    [9] = { ['item'] = 'adrenalina', ['nome']='Adrenalina'},
    [10] = { ['item'] = 'bandagem', ['nome']='Bandagem'},
    
}
config.DrawMarkerFuga = function(x,y,z) -- Configuração do DrawMarker
    DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255, 0, 0,100,0,0,0,1)
end

config.DrawText3DFuga = function(x,y,z) 
    DrawText3D(x,y,z+0.99,"~r~Pressione  ~n~ ~f~E~w~  ~n~  ~r~para tentar fugir~w~") -- Configuração do texto do blip
end
config.DrawText3DProcure = function(x,y,z) 
    DrawText3D(x,y,z+0.99,"~r~Pressione  ~n~ ~f~E~w~  ~n~ ~r~para procurar~w~ ") -- Configuração do texto do blip
end

-- [ 3D Text function ] --
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- drawTxt
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

return config