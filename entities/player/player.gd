extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _tick_digging = $TickDigging
@export var speed = 16
@export var mining_speed = 15
@export var camera = Camera2D
@onready var world: MineableLayer = $"../Level/FG"

# Movement directions
enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var facing: Vector2
var moving: bool
var interacting: bool
var queue = [null] # https://www.reddit.com/r/godot/comments/1anpsdz/a_proper_4way_movement_system_for_keyboard_input/

func _ready():
	var mask: int = world.tile_set.get_physics_layer_collision_layer(0)
	print(mask)

func _physics_process(delta):
	for input in ["ui_left", "ui_right", "ui_up", "ui_down", "ui_select"]:
		if Input.is_action_just_pressed(input): queue.push_back(input)
		if Input.is_action_just_released(input): queue.erase(input)

	var direction = Vector2.ZERO
	match queue.back():
		"ui_left":
			direction = Vector2.LEFT
			facing = Vector2.LEFT
			moving = true
			interacting = false
			_tick_digging.stop()
		"ui_right":
			direction = Vector2.RIGHT
			facing = Vector2.RIGHT
			moving = true
			interacting = false
			_tick_digging.stop()
		"ui_up":
			direction = Vector2.UP
			facing = Vector2.UP
			moving = true
			interacting = false
			_tick_digging.stop()
		"ui_down":
			direction = Vector2.DOWN
			facing = Vector2.DOWN
			moving = true
			interacting = false
			_tick_digging.stop()
		"ui_select":
			moving = false
			interacting = true
			if _tick_digging.is_stopped():
				_tick_digging.start()
		_:
			direction = Vector2.ZERO
			moving = false
			interacting = false
			_tick_digging.stop()

	velocity = direction * speed

	# TODO: Lock player to grid?
	move_and_slide()
	
	


func _process(delta):
	if moving:
		play_anim("move")
	elif interacting:
		play_anim("interact")
	else:
		play_anim("idle")

func play_anim(action):
	match facing:
		Vector2.UP:
			_animated_sprite.flip_h = false
			_animated_sprite.play(action+"_back")
		Vector2.DOWN:
			_animated_sprite.flip_h = false
			_animated_sprite.play(action+"_front")
		Vector2.LEFT:
			_animated_sprite.flip_h = true
			_animated_sprite.play(action+"_side")
		Vector2.RIGHT:
			_animated_sprite.flip_h = false
			_animated_sprite.play(action+"_side")


func _on_tick_digging_timeout() -> void:
	# TODO: The initial idea of having a massive array in a MineableLayer class
	#	ISNT going to work. Creating an array the size of the whole map probably
	#	will NOT scale.
	
	# https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(position, position + facing * 8, 1)
	query.exclude = [self]
	query.collide_with_areas = false
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result == {}:
		return
	#print(result)
	
	var target_cell = world.local_to_map(result["position"] + (facing * 0.1)) # penetrate ray slightly to ensure correct tile is detected.
	print(target_cell)
	var toughness = world.get_cell_toughness(target_cell)
	
	print(str(toughness), "->", str(toughness - 15))
	world.set_cell_toughness(target_cell, toughness - 15)
	
	if toughness - 15 <= 0:
		print("Broke cell")
		world.set_cell(target_cell)
		print(world.get_cell_toughness(target_cell))
