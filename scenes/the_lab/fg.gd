extends TileMapLayer
class_name MineableLayer

var toughness = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: This is really dumb now that I think about it. This would require iterating through the ENTIRE
	#	map on startup. Remove this crap and maybe keep the data in the player script that just adds 
	#	a list of accumulated damage for the player.
	var dimensions = get_used_rect().size
	print(dimensions)
	for y in dimensions.y:
		toughness.append([])
		for x in dimensions.x:
			var cell = Vector2i(x, y)
			var data = get_cell_tile_data(cell)
			
			if not data: continue
			
			var cell_toughness = data.get_custom_data("toughness")
			if not cell_toughness: continue
			print("Assigned toughness value of ", str(cell_toughness), " to ", str(cell))
			toughness[y].append(cell_toughness)

func set_grid_value(position: Vector2i, object: int):
	toughness[position.y][position.x] = object
	
func get_grid_value(position: Vector2i) -> int:
	return toughness[position.y][position.x]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
