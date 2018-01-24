require "util"

script.on_event(defines.events.on_player_changed_position, function(event)
	local player = game.players[event.player_index]
	if player.driving then
		local spot = isNearParkingSpot(player.position)
		if spot then
			player.vehicle.teleport(spot)
			orientVehicle(player.vehicle)
		end
	end
end)

function isNearParkingSpot(position
	for i, spot in pairs(global.parking_spots) do
		blah
	end
end

function orientVehicle(vehicle, direction)
	if direction = defines.direction.east then
		vehicle.orientation = 0.25
	elseif direction = defines.direction.south then
		vehicle.orientation = 0.5
	elseif direction = defines.direction.west then
		vehicle.orientation = 0.75
	else
		vehicle.orientation = 0
	end
end

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	if entity.name == "parking-spot" then
		global.parking_spots = global.parking_spots or {}
		global.parking_spots[entity.unit_number] = entity.position
	end
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	local entity = event.created_entity
	if entity.name == "parking-spot" then
		global.parking_spots = global.parking_spots or {}
		global.parking_spots[entity.unit_number] = entity.position
	end
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
	local entity = event.entity
	if entity.name == "parking-spot" then
		global.parking_spots[entity.unit_number] = nil
	end
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
	local entity = event.entity
	if entity.name == "parking-spot" then
		global.parking_spots[entity.unit_number] = nil
	end
end)


