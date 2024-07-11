extends CharacterBody2D

var dir = Vector2.ZERO

var zoom = 0
var cap_speed = 20
var last_velocity = 0

func _process(delta: float) -> void:
	dir.y = Input.get_action_raw_strength("ui_down") - Input.get_action_raw_strength("ui_up")
	dir.x = Input.get_action_raw_strength("ui_right") - Input.get_action_raw_strength("ui_left")
	if Input.is_action_just_pressed("scroll_up"):
		zoom = clamp(zoom+1,0,2)
	elif Input.is_action_just_pressed("scroll_down"):
		zoom = clamp(zoom-1,0,2)
		
	match zoom:
		0:
			$Camera2D.zoom = Vector2(0.5,0.5)
		1:
			$Camera2D.zoom = Vector2(1,1)
		2:
			$Camera2D.zoom = Vector2(2,2)
	

func _physics_process(delta: float) -> void:
	velocity += dir*0.2
	
	if dir == Vector2(0, 0):
		# drag example for demo
		velocity *= 0.98

	
	
	#velocity = velocity.clamp(Vector2(-cap_speed,-cap_speed),Vector2(cap_speed,cap_speed))
		
	last_velocity = velocity.length()/1.02
	
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * ((last_velocity*delta))
