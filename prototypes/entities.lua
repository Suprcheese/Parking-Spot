local parking_spot = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])

parking_spot.name = "parking-spot"
parking_spot.icon = "__Parking-Spot__/graphics/ParkingSpotIcon.png"
parking_spot.icon_size = 32
parking_spot.order = "p-s"
parking_spot.render_layer = "floor-mechanics"
parking_spot.flags = {"placeable-player", "building-direction-8-way"}
parking_spot.minable = {mining_time = 0.4, result = "parking-spot"}
parking_spot.collision_box = {{-1, -1}, {1, 1}}
parking_spot.selection_box = {{-1, -1}, {1, 1}}
parking_spot.picture =
{
	filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
	priority = "low",
	width = 46,
	height = 33,
	-- shift = {0.25, 0.015625}
}
parking_spot.collision_mask = {"water-tile"}


local parking_spot_occupied = table.deepcopy(data.raw["simple-entity-with-force"]["simple-entity-with-force"])

parking_spot_occupied.name = "parking-spot-occupied"
parking_spot_occupied.icon = "__Parking-Spot__/graphics/ParkingSpotIcon.png"
parking_spot_occupied.icon_size = 32
parking_spot_occupied.render_layer = "floor-mechanics"
parking_spot_occupied.order = "p-s-o"
parking_spot_occupied.flags = {"building-direction-8-way"}
parking_spot_occupied.minable = {mining_time = 0.4, result = "parking-spot"}
parking_spot_occupied.collision_box = {{-1, -1}, {1, 1}}
parking_spot_occupied.selection_box = {{-1, -1}, {1, 1}}
parking_spot_occupied.picture =
{
	filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
	priority = "low",
	width = 46,
	height = 33,
	-- shift = {0.25, 0.015625}
}
parking_spot_occupied.collision_mask = {"water-tile"}

data:extend({parking_spot, parking_spot_occupied})
