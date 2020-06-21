local Vehicles = nil


local tbl = {
[1] = {player = nil},
[2] = {player = nil},
[3] = {player = nil},
[4] = {player = nil},
[5] = {player = nil},
[6] = {player = nil},
}
AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")

AddEventHandler("LSC:buttonSelected", function(name, button)
    local src = source
    local dataUser = exports["drp_id"]:GetCharacterData(src)
	TriggerEvent("DRP_Bank:GetCharacterMoney", dataUser.charid, function(characterMoney)
		local userMoney = characterMoney.data[1].cash
        local mymoney = tonumber(button.price)

        -- check if button have price
        if button.price then
            if button.price < userMoney then
				TriggerClientEvent("LSC:buttonSelected", src, name, button, true)
				TriggerEvent("DRP_Bank:RemoveCashMoney", dataUser, tonumber(button.price))
                TriggerClientEvent('LSC:installMod', src)
            else
                TriggerClientEvent("LSC:buttonSelected", src, name, button, false)
                TriggerClientEvent('LSC:cancelInstallMod', src)
            end
        end
    end)
end)

RegisterServerEvent("LSC:refreshOwnedVehicle")
AddEventHandler("LSC:refreshOwnedVehicle", function(plate, data, fuel_level)
	--print('UpdateVehicle: '.. fuel_level)
	local src = source
	local character = exports["drp_id"]:GetCharacterData(src)
	-- pull all data for cars -> loop it and compare from passed data?
	exports["externalsql"]:AsyncQueryCallback({
		query = "SELECT * FROM `vehicles` WHERE `char_id` = :charid",
		data = {
			charid = character.charid
		}
	}, function(allVehicleData)
		local vehicleData = allVehicleData["data"]
			for a = 1, #vehicleData, 1 do
				local allPlates = json.decode(vehicleData[a]["vehicleMods"])
				if allPlates.plate == plate then
				exports["externalsql"]:AsyncQueryCallback({
					query = "UPDATE vehicles SET plate = :plate, vehicleMods = :vehicleMods, fuel_level = :fuel_level WHERE `plate` = :plate",
					data = {
						plate = plate,
						vehicleMods = json.encode(data),
						--fuel_level = fuel_level
					}
				}, function(results)
				end)
			end
		end
	end)
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
	local bulletProofTyres = veh.bulletProofTyres
	--Do w/e u need with all this stuff when vehicle drives out of lsc
end)
