ESX                           = nil
local GUI					  = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
GUI.Time           			  = 0
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("esx_infoillegal:notify")
AddEventHandler("esx_infoillegal:notify", function(icon, type, sender, title, text)
    Citizen.CreateThread(function()
		Wait(1)
		SetNotificationTextEntry("STRING");
		AddTextComponentString(text);
		SetNotificationMessage(icon, icon, true, type, sender, title, text);
		DrawNotification(false, true);
    end)
end)


function OpenInfoIllegalMenu()

  local elements = { }
	  table.insert(elements, {label = _U('weed') .. Config.PriceWeedF .. _U('weed1'),    value = 'weed'})
	  table.insert(elements, {label = _U('tweed') .. Config.PriceWeedT .. _U('tweed1'),    value = 'tweed'})
	  table.insert(elements, {label = _U('rweed') .. Config.PriceWeedR .. _U('rweed1'),    value = 'rweed'})

  ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'info',
      {
        title    = _U('info'),
        align    = 'top-left',
        elements = elements,
        },

        function(data, menu)

        if data.current.value == 'weed' then
           TriggerServerEvent("esx_infoillegal:Weed")
		   ESX.UI.Menu.CloseAll()
        end
		
		if data.current.value == 'tweed' then
           TriggerServerEvent("esx_infoillegal:TWeed")
		   ESX.UI.Menu.CloseAll()
        end
		if data.current.value == 'rweed' then
           TriggerServerEvent("esx_infoillegal:RWeed")
		   ESX.UI.Menu.CloseAll()
        end

      CurrentAction     = 'menu_info_illegal'
      CurrentActionData = {}

    end,
    function(data, menu)

      menu.close()

      CurrentAction     = 'menu_info_illegal'
      CurrentActionData = {}
    end
    )

end

RegisterNetEvent("esx_infoillegal:WeedFarm")
AddEventHandler("esx_infoillegal:WeedFarm", function()
	if Config.GPS then
		x, y, z = Config.WeedFarm.x, Config.WeedFarm.y, Config.WeedFarm.z
		SetNewWaypoint(x, y, z)
		local source = GetPlayerServerId();
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('GPS'))
	else
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('RecWeed'))
	end
end)

RegisterNetEvent("esx_infoillegal:WeedTreatment")
AddEventHandler("esx_infoillegal:WeedTreatment", function()
	if Config.GPS then
		x, y, z = Config.WeedTreatment.x, Config.WeedTreatment.y, Config.WeedTreatment.z
		SetNewWaypoint(x, y, z)
		local source = GetPlayerServerId();
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('GPS'))
	else
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('TraiWeed1'))
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('TraiWeed'))
	end
end)

RegisterNetEvent("esx_infoillegal:WeedResell")
AddEventHandler("esx_infoillegal:WeedResell", function()
	if Config.GPS then
		x, y, z = Config.WeedResell.x, Config.WeedResell.y, Config.WeedResell.z
		SetNewWaypoint(x, y, z)
		local source = GetPlayerServerId();
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('GPS'))
	else
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('RevWeed1'))
		TriggerEvent("esx_infoillegal:notify", "CHAR_LESTER_DEATHWISH", 1, _U('Notification'), false, _U('RevWeed'))
	end
end)

AddEventHandler('esx_infoillegal:hasEnteredMarker', function(zone)
	CurrentAction     = 'menu_info_illegal'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_infoillegal:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
if Config.Blip then
	Citizen.CreateThread(function ()
		for k,v in ipairs(Config.Zones)do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite (blip, 133)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.0)
			SetBlipColour (blip, 5)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('illegalblip'))
			EndTextCommandSetBlipName(blip)
		end
	end)
end

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil
		
		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.MarkerSize.x / 2) then
				isInMarker  = true
				currentZone = k
			end
		end
		
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_infoillegal:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_infoillegal:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

       if IsControlJustReleased(0, 38) and (GetGameTimer() - GUI.Time) > 1000 then
		heure		= tonumber(GetClockHours())
		GUI.Time 	= GetGameTimer()
		
        if CurrentAction == 'menu_info_illegal' then
			if Config.Hours then
				if heure > Config.openHours and heure < Config.closeHours then	
					OpenInfoIllegalMenu()
				else
					TriggerServerEvent('esx_infoillegal:Nothere')
				end
			else
				OpenInfoIllegalMenu()
			end
        end

        CurrentAction = nil
      end

    end
  end
end)
