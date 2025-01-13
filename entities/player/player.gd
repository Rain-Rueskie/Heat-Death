extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@export var speed = 16

# Movement directions
enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var facing: Direction
var moving: bool
var interacting: bool
var queue = [null] # https://www.reddit.com/r/godot/comments/1anpsdz/a_proper_4way_movement_system_for_keyboard_input/

func _physics_process(delta):
	for input in ["ui_left", "ui_right", "ui_up", "ui_down", "ui_select"]:
		if Input.is_action_just_pressed(input): queue.push_back(input)
		if Input.is_action_just_released(input): queue.erase(input)

	var direction = Vector2.ZERO
	match queue.back():
		"ui_left":
			direction = Vector2.LEFT
			facing = Direction.LEFT
			moving = true
		"ui_right":
			direction = Vector2.RIGHT
			facing = Direction.RIGHT
			moving = true
		"ui_up":
			direction = Vector2.UP
			facing = Direction.UP
			moving = true
		"ui_down":
			direction = Vector2.DOWN
			facing = Direction.DOWN
			moving = true
		"ui_select":
			moving = false
			interacting = true
		_:
			direction = Vector2.ZERO
			moving = false
			interacting = false

	velocity = direction * speed

	# TODO: Lock player to grid
	move_and_slide()

var zoom = 0

func _process(delta):
	if Input.is_action_just_pressed("scroll_up"):
		zoom = clamp(zoom+1,0,2)
	elif Input.is_action_just_pressed("scroll_down"):
		zoom = clamp(zoom-1,0,2)
		
	match zoom:
		0:
			$Camera2D.zoom = Vector2(1,1)
		1:
			$Camera2D.zoom = Vector2(2,2)
		2:
			$Camera2D.zoom = Vector2(3,3)
	
	if moving:
		play_anim("move")
	elif interacting:
		play_anim("interact")
	else:
		play_anim("idle")

func play_anim(action):
	match facing:
		Direction.UP:
			_animated_sprite.flip_h = false
			_animated_sprite.play(action+"_back")
		Direction.DOWN:
			_animated_sprite.flip_h = false
			_animated_sprite.play(action+"_front")
		Direction.LEFT:
			_animated_sprite.flip_h = true
			_animated_sprite.play(action+"_side")
		Direction.RIGHT:
			_animated_sprite.flip_h = false
			_animated_sprite.play(action+"_side")
