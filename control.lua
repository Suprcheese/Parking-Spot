require "util"
require "stdlib/area/position"

script.on_init(function() On_Init() end)
script.on_configuration_changed(function() On_Init() end)

function On_Init()
	global.vacant_parking_spots = global.vacant_parking_spots or {}
	global.occupied_parking_spots = global.occupied_parking_spots or {}
end

script.on_event(defines.events.on_player_changed_position, function(event)
	local player = game.players[event.player_index]
	if player.driving and not player.vehicle.train then
		local vehicle = player.vehicle
		local spot = isNearVacantParkingSpot(player, vehicle)
		if spot then
			local vacant_spot = spot[2]
			local direction = vacant_spot.direction
			vehicle.speed = 0
			vehicle.teleport(spot[1])
			orientVehicle(vehicle, direction) -- Snap to 8-way direction
			-- player.play_sound(maybe)
			global.vacant_parking_spots[vacant_spot.unit_number] = nil
			local occupied_spot = vacant_spot.surface.create_entity({name = "parking-spot-occupied", position = vacant_spot.position, direction = direction, force = vacant_spot.force})
			occupied_spot.destructible = false
			global.occupied_parking_spots[occupied_spot.unit_number] = occupied_spot
			vacant_spot.destroy()
			disableNearbyVacantParkingSpots(occupied_spot)
			player.driving = false
			game.players[1].print("Beep!")
		end
	end
end)

function isNearVacantParkingSpot(player, vehicle)
	for i, spot in pairs(global.vacant_parking_spots) do
		local pos = spot.position
		if Position.distance(player.position, pos) < 5 then
			local available_position = player.surface.find_non_colliding_position(vehicle.name, pos, 0.5, 0.25)
			if available_position then return {available_position, spot} end
		end
	end
	return false
end

function orientVehicle(vehicle, direction)	-- ORIENTATIONS: 0 is North, 0.25 is East, 0.5 is South, 0.75 is West
	local current_orientation = vehicle.orientation
	if (direction == defines.direction.east) or (direction == defines.direction.west) then
		if current_orientation >= 0 and current_orientation < 0.5 then
			vehicle.orientation = 0.25
		else
			vehicle.orientation = 0.75
		end
	elseif (direction == defines.direction.northeast) or (direction == defines.direction.southwest) then
		if (current_orientation >= 0 and current_orientation < 0.375) or (current_orientation >= 0.875) then
			vehicle.orientation = 0.125
		else
			vehicle.orientation = 0.625
		end
	elseif (direction == defines.direction.northwest) or (direction == defines.direction.southeast) then
		if current_orientation >= 0.125 and current_orientation < 0.625 then
			vehicle.orientation = 0.375
		else
			vehicle.orientation = 0.875
		end
	else -- Else must be North/South (or invalid)
		if (current_orientation >= 0 and current_orientation < 0.25) or (current_orientation >= 0.75) then
			vehicle.orientation = 0
		else
			vehicle.orientation = 0.5
		end
	end
end

function disableNearbyVacantParkingSpots(spot)
	local vacant_spots = spot.surface.find_entities_filtered({area = Position.expand_to_area(spot.position, 6), name = "parking-spot"})
	for i, vacant_spot in pairs(vacant_spots) do
		global.vacant_parking_spots[vacant_spot.unit_number] = nil
		local occupied_spot = vacant_spot.surface.create_entity({name = "parking-spot-occupied", position = vacant_spot.position, direction = vacant_spot.direction, force = vacant_spot.force})
		occupied_spot.destructible = false
		global.occupied_parking_spots[occupied_spot.unit_number] = occupied_spot
		vacant_spot.destroy()
	end
end

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	if entity.name == "parking-spot" then
		entity.destructible = false
		global.vacant_parking_spots[entity.unit_number] = entity
	end
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	local entity = event.created_entity
	if entity.name == "parking-spot" then
		entity.destructible = false
		global.vacant_parking_spots[entity.unit_number] = entity
	end
end)

script.on_event(defines.events.on_pre_player_mined_item, function(event)
	local entity = event.entity
	if entity.name == "parking-spot" then
		if global.vacant_parking_spots[entity.unit_number] then
			global.vacant_parking_spots[entity.unit_number] = nil
			return
		end
	elseif entity.name == "parking-spot-occupied" then
		if global.occupied_parking_spots[entity.unit_number] then
			global.occupied_parking_spots[entity.unit_number] = nil
		end
	end
end)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
	local entity = event.entity
	if entity.name == "parking-spot" then
		if global.vacant_parking_spots[entity.unit_number] then
			global.vacant_parking_spots[entity.unit_number] = nil
			return
		end
	elseif entity.name == "parking-spot-occupied" then
		if global.occupied_parking_spots[entity.unit_number] then
			global.occupied_parking_spots[entity.unit_number] = nil
		end
	end
end)

script.on_event(defines.events.on_canceled_deconstruction, function(event)
	local entity = event.entity
	if entity.name == "parking-spot" then
		global.vacant_parking_spots[entity.unit_number] = entity
		return
	elseif entity.name == "parking-spot-occupied" then
		global.occupied_parking_spots[entity.unit_number] = entity
	end
end)
