extends StaticBody2D

# https://docs.godotengine.org/en/latest/classes/class_timer.html#class-timer

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _hitbox = $Hitbox
var is_open = false

func _on_entrance_body_entered(body: Node2D) -> void:
	if body.name == "Controller":
		is_open = true
		_animated_sprite.play("opening")
	pass # Replace with function body.


func _on_entrance_body_exited(body: Node2D) -> void:
	if body.name == "Controller":
		is_open = false
		_animated_sprite.play("closing")
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_open:
		_hitbox.disabled = true
	else:
		_hitbox.disabled = false
	pass # Replace with function body.
