extends Camera2D

@export var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	update_camera();

var zoomf = 2

func _process(delta):
	update_camera();
	
	if Input.is_action_just_pressed("scroll_up"):
		zoomf = clamp(zoomf+1,0,2)
	elif Input.is_action_just_pressed("scroll_down"):
		zoomf = clamp(zoomf-1,0,2)

	zoom = Vector2(zoomf+1, zoomf+1)

func update_camera():
	if is_instance_valid(target):
		position = Vector2(round(target.position.x), round(target.position.y))
		#position = target.position;
		#print(position)
