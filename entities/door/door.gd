extends StaticBody2D

"""
Theory of operation:
	- Player can enter from any direction (Other tiles with hitboxes will restrict what direction this will be.)
	- Once player enters, take 0.5 seconds for the "processing" to occur (sfx, animation, etc)
	- Player can exit any door based on the direction the player goes.
	
	This is sorta like a filter to prevent hostiles from entering. It shouldn't be inconvenient to use.
	This door also allows things to transition from strut to a path (more efficient and fast)
	
	Strut: Exterior of ship, cheap, but slow for robots
	Path: Interior of ship, must be surrounded on 4 sides, more expensive, fast for robots.
"""

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _north_sensor = $NorthSensor
@onready var _east_sensor = $EastSensor
@onready var _south_sensor = $SouthSensor
@onready var _west_sensor = $WestSensor
@onready var _north_door = $NorthDoor
@onready var _east_door = $EastDoor
@onready var _south_door = $SouthDoor
@onready var _west_door = $WestDoor
@onready var _occupation_sensor = $OccupationSensor

enum directions {
	NORTH,
	EAST,
	SOUTH,
	WEST
}

enum actions {
	OPEN,
	CLOSE
}

var state = {
	directions.NORTH: 0,
	directions.EAST: 0,
	directions.SOUTH: 0,
	directions.WEST: 0
}

func get_animation(direction: directions, action: actions) -> String:
	print("Playing animation: ", str(directions.keys()[direction].to_lower(), "_", actions.keys()[action].to_lower()))
	return str(directions.keys()[direction].to_lower(), "_", actions.keys()[action].to_lower())

func close_direction(direction: directions) -> void:
	# TODO: Not implemented
	state[direction] = 0
	# TODO: Enable hitbox for direction.
	_animated_sprite.play(get_animation(direction, actions.CLOSE))
	await _animated_sprite.animation_finished
	return

func open_direction(direction: directions) -> void:
	# check if any door is open that's not the current door.
	for door in state:
		print("Door: ", str(door))
		print(direction)
		if door != direction and state[door]:
			print("Door ", door, " is open! Closing")
			await close_direction(door)
		print(door, state[door])
		if door == direction and state[door]:
			# The requested open direction is already open.
			print("FOO!")
			return
			
	
	# TODO: Now open the requested direction.
	state[direction] = 1
	_animated_sprite.play(get_animation(direction, actions.OPEN))
	await _animated_sprite.animation_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_north_sensor_body_entered(body: Node2D) -> void:
	if body.name != "Controller": return
	await open_direction(directions.NORTH)
	pass # Replace with function body.


func _on_east_sensor_body_entered(body: Node2D) -> void:
	if body.name != "Controller": return
	await open_direction(directions.EAST)
	pass # Replace with function body.


func _on_south_sensor_body_entered(body: Node2D) -> void:
	if body.name != "Controller": return
	await open_direction(directions.SOUTH)
	pass # Replace with function body.


func _on_west_sensor_body_entered(body: Node2D) -> void:
	if body.name != "Controller": return
	await open_direction(directions.WEST)
	pass # Replace with function body.
