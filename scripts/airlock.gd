extends StaticBody2D

# https://docs.godotengine.org/en/latest/classes/class_timer.html#class-timer

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _airlock_entrance_timer = $AirlockEntranceTimer
@onready var _airlock_exit_timer = $AirlockExitTimer
@onready var _airlock_interchange_timer = $InterchangeTimer
@onready var _wallE = $WallE
@onready var _wallW = $WallW
var outside_open = false
var inside_open = false

func _on_entrance_body_entered(body: Node2D) -> void:
	if body.name == "Controller":
		print("Requesting outer hatch opening!")
		_airlock_entrance_timer.start()
		if not outside_open:
			_animated_sprite.play("outside_open")
			outside_open = true


func _on_entrance_body_exited(body: Node2D) -> void:
	if body.name == "Controller":
		_airlock_entrance_timer.stop()
		if outside_open:
			_animated_sprite.play("outside_close")
			outside_open = false
		print("Outer hatch request ended.")


func _on_airlock_entrance_timer_timeout() -> void:
	print("Opening outer hatch!")
	_wallE.disabled = true
	_wallW.disabled = false


func _on_occupation_body_entered(body: Node2D) -> void:
	if body.name == "Controller":
		_airlock_interchange_timer.start()


func _on_interchange_timer_timeout() -> void:
	if _wallE.disabled:
		print("Interchange Entering")
		_animated_sprite.play("inside_open")
		inside_open = true
		_wallE.disabled = false
		_wallW.disabled = true
	elif _wallW.disabled:
		print("Interchange Exiting")
		_animated_sprite.play("outside_open")
		outside_open = true
		_wallE.disabled = true
		_wallW.disabled = false


func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Controller":
		print("Requesting inner hatch open!")
		_airlock_exit_timer.start()
		if not inside_open:
			_animated_sprite.play("inside_open")
			inside_open = true


func _on_exit_body_exited(body: Node2D) -> void:
	if body.name == "Controller":
		_airlock_exit_timer.stop()
		if inside_open:
			_animated_sprite.play("inside_close")
			inside_open = false
		print("Inner hatch request ended.")


func _on_airlock_exit_timer_timeout() -> void:
	print("Opening inner hatch!")
	_wallW.disabled = true
	_wallE.disabled = false
