extends StaticBody2D

@onready var _animated_sprite = $AnimatedSprite2D

func _on_entrance_body_entered(body: Node2D) -> void:
	if body.name == "Controller":
		_animated_sprite.play("opening")
	pass # Replace with function body.


func _on_entrance_body_exited(body: Node2D) -> void:
	if body.name == "Controller":
		_animated_sprite.play("closing")
	pass # Replace with function body.
