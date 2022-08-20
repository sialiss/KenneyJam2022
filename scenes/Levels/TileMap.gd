extends TileMap


onready var BurrowableTileMap = $"%BurrowableTileMap"
onready var UnburrowableTileMap = $"%UnburrowableTileMap"


export(Array, int) var burrowable_indexes = []
export(Array, int) var unburrowable_indexes = []


func _ready():
	var collision_tile_maps = [
		BurrowableTileMap,
		UnburrowableTileMap
	]

	var collisions = {}
	for index in burrowable_indexes:
		collisions[index] = 0
	for index in unburrowable_indexes:
		collisions[index] = 1

	for cell_position in get_used_cells():
		var cell = get_cellv(cell_position)
		if cell in collisions:
			var collision_tile_map = collision_tile_maps[collisions[cell]]
			collision_tile_map.set_cellv(cell_position, 0)
