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

var state = {
	directions.NORTH: 0,
	directions.EAST: 0,
	directions.SOUTH: 0,
	directions.WEST: 0
}

func close_direction(direction: directions) -> void:
	# TODO: Not implemented
	state[direction] = 0
	pass

func open_direction(direction: directions) -> void:
	# check if any door is open that's not the current door.
	for door in state:
		if door != direction and state[door]:
			print("Door ", door, " is open! Closing")
			await close_direction(door)
		print(door, state[door])
		if door == direction:
			print("FOO!")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_direction(directions.NORTH)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
