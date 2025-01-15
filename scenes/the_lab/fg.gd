extends TileMapLayer
class_name MineableLayer

var cell_data = {}
"""
cell_data {
	Vector2i: {
		toughness: int,
		max_toughness: int
		...
	}
}

If Vector2i NOT in dictionary, assume full health

Thanks to ElFrijole on the GoDot Discord for this idea.
"""

# TODO: Perhaps look into moving this to the Node2D containing the layers so tiles can be
#	automatically transferred to the background layer.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_grid_data(position: Vector2i, attribute: String, value: int):
	cell_data[position][attribute] = value
	
func get_grid_data(position: Vector2i) -> Dictionary:
	return cell_data[position]

func get_cell_toughness(position: Vector2i) -> int:
	if not cell_data.has(position):
		var data = get_cell_tile_data(position)
		if not data: return -1001
		var cell_toughness = data.get_custom_data("toughness")
		if not cell_toughness: return -1002
		return cell_toughness
	else:
		return cell_data[position]["toughness"]

func set_cell_toughness(position: Vector2i, value: int) -> int:
	if not cell_data.has(position):
		# add position to cell data, set toughness value to new value and set max_toughness to grid value
		cell_data[position] = {
			toughness = value,
			max_toughness = get_cell_toughness(position)
		}
	else:
		cell_data[position]["toughness"] = value
	
	return cell_data[position]["toughness"]

func get_cell_bg_tile(position: Vector2i) -> Vector2i:
	var data = get_cell_tile_data(position)
	if not data: return Vector2i(-1, -1)
	var bg_tile = data.get_custom_data("bg")
	if not bg_tile: return Vector2i(-1, -1)
	return bg_tile

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
