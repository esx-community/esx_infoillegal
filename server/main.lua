RegisterServerEvent('esx_infoillegal:Weed')
AddEventHandler('esx_infoillegal:Weed', function()
	local source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.getMoney()) >= Config.PriceWeedF) then
			user.removeMoney(Config.PriceWeedF)
			TriggerClientEvent("esx_infoillegal:WeedFarm", source)
		else
			TriggerClientEvent("esx_infoillegal:notify", source, "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('NoCash'))
		end
	end)
end)

RegisterServerEvent('esx_infoillegal:TWeed')
AddEventHandler('esx_infoillegal:TWeed', function()
	local source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.getMoney()) >= Config.PriceWeedT) then
			user.removeMoney(Config.PriceWeedT)
			TriggerClientEvent("esx_infoillegal:WeedTreatment", source)			
		else
			TriggerClientEvent("esx_infoillegal:notify", source, "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('NoCash'))
		end
	end)
end)

RegisterServerEvent('esx_infoillegal:RWeed')
AddEventHandler('esx_infoillegal:RWeed', function()
	local source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.getMoney()) >= Config.PriceWeedR) then
			user.removeMoney(Config.PriceWeedR)
			TriggerClientEvent("esx_infoillegal:WeedResell", source)				
		else
			TriggerClientEvent("esx_infoillegal:notify", source, "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('NoCash'))
		end
	end)
end)

RegisterServerEvent('esx_infoillegal:Nothere')
AddEventHandler('esx_infoillegal:Nothere', function()
	TriggerClientEvent("esx_infoillegal:notify", source, "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('Nothere'))
end)