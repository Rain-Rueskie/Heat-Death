extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

# Define the size of each grid cell
const GRID_SIZE = 8

# Movement directions
enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var facing: Direction

# Current target position
var target_position: Vector2

# Flag to check if the character is moving
var is_moving = false

func _ready():
	# Initialize the target position to the current position
	target_position = position

func _physics_process(delta):
	# Handle input only if not moving
	if not is_moving:
		if Input.is_action_pressed("ui_up"):
			move_to(Direction.UP)
		elif Input.is_action_pressed("ui_down"):
			move_to(Direction.DOWN)
		elif Input.is_action_pressed("ui_left"):
			move_to(Direction.LEFT)
		elif Input.is_action_pressed("ui_right"):
			move_to(Direction.RIGHT)
		else:
			play_anim_idle()

	# Smoothly move towards the target position
	if is_moving:
		velocity = (target_position - position).normalized() * GRID_SIZE * 2
		move_and_slide()
		if position.distance_to(target_position) < 1:
			position = target_position
			is_moving = false

func play_anim_idle():
	match facing:
		Direction.UP:
			_animated_sprite.flip_h = false
			_animated_sprite.play("idle_back")
		Direction.DOWN:
			_animated_sprite.flip_h = false
			_animated_sprite.play("idle_front")
		Direction.LEFT:
			_animated_sprite.flip_h = true
			_animated_sprite.play("idle_side")
		Direction.RIGHT:
			_animated_sprite.flip_h = false
			_animated_sprite.play("idle_side")

func move_to(direction: int):
	match direction:
		Direction.UP:
			_animated_sprite.flip_h = false
			_animated_sprite.play("move_back")
			target_position = position + Vector2(0, -GRID_SIZE)
		Direction.DOWN:
			_animated_sprite.flip_h = false
			_animated_sprite.play("move_front")
			target_position = position + Vector2(0, GRID_SIZE)
		Direction.LEFT:
			_animated_sprite.flip_h = true
			_animated_sprite.play("move_side")
			target_position = position + Vector2(-GRID_SIZE, 0)
		Direction.RIGHT:
			_animated_sprite.flip_h = false
			_animated_sprite.play("move_side")
			target_position = position + Vector2(GRID_SIZE, 0)
	
	facing = direction
	
	# Check for collision and set is_moving to true if no collision
	if not is_moving:
		is_moving = true
