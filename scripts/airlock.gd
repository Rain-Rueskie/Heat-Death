extends StaticBody2D

# https://docs.godotengine.org/en/latest/classes/class_timer.html#class-timer
# TODO: Make door close after an amount of time not occupied.


@onready var _animated_sprite = $AnimatedSprite2D
@onready var _wallE = $WallE
@onready var _wallW = $WallW
@onready var _exit_sensor = $Exit
@onready var _enter_sensor = $Entrance
@onready var _occupation_sensor = $Occupation
var outside_open = false
var inside_open = false
enum door_direction {
	ENTERING,
	EXITING,
	NONE
}
var entering_or_exiting: door_direction = door_direction.NONE

func area_contains_name(sensor: Area2D, name: String):
	return sensor.get_overlapping_bodies().filter(func(element): return element.name == name)

func _on_occupation_body_entered(body: Node2D) -> void:
	if body.name != "Controller": return
	
	# If the entrance sensor is active too while entering, this means the controller is entering
	# from the entrance side. This is visa versa for the exit sensor as seen in the next statement.
	if area_contains_name(_enter_sensor, "Controller"):
		print("Area entered, awaiting full entry...")
		# Await for the entrance sensor to have something exit it. If it's the controller
		# then that means the controller has either entered the airlock or cancelled.
		# We will check for this second case later.
		var controller_exits_sensor = false
		while true: # I feel like this is going to break something eventually.
			var exit_body = await _enter_sensor.body_exited
			if body.name == "Controller":
				break
		
		if not area_contains_name(_occupation_sensor, "Controller"):
			print("Controller has abandoned airlock request, return...")
			return
		
		_wallE.set_deferred("disabled", false) # Close outside hitbox
		if outside_open: # If sprite outside is open, close with animation.
			outside_open = false
			_animated_sprite.play("outside_close")
		entering_or_exiting = door_direction.ENTERING
		print("Entered fully!")
	
	elif area_contains_name(_exit_sensor, "Controller"):
		var controller_exits_sensor = false
		while true: # I feel like this is going to break something eventually.
			var exit_body = await _exit_sensor.body_exited
			if body.name == "Controller":
				break
		
		if not area_contains_name(_occupation_sensor, "Controller"):
			print("Controller has abandoned airlock request, return...")
			return
		
		_wallW.set_deferred("disabled", false) # Close inside hitbox
		if inside_open: # If inside sprite is open, close with animation
			inside_open = false
			_animated_sprite.play("inside_close")
		entering_or_exiting = door_direction.EXITING
		print("Exited fully!")
	
	await get_tree().create_timer(5).timeout
	
	if entering_or_exiting == door_direction.ENTERING:
		_wallW.set_deferred("disabled", true) # open inside hitbox
		if not inside_open:
			inside_open = true
			_animated_sprite.play("inside_open")
	elif entering_or_exiting == door_direction.EXITING:
		_wallE.set_deferred("disabled", true) # open outside hitbox
		if not outside_open:
			outside_open = true
			_animated_sprite.play("outside_open")
	
func _on_entrance_body_entered(body: Node2D) -> void:
	if body.name != "Controller": return
	
	print("Requesting outer hatch opening!")
	_wallW.set_deferred("disabled", false) # Close inside hitbox
	if inside_open: # If inside is open, close and await the animation.
		inside_open = false
		_animated_sprite.play("inside_close")
		await _animated_sprite.animation_finished
	
	_wallE.set_deferred("disabled", true) # Open outside hitbox
	if not outside_open: # If outside is closed, play open animation
		outside_open = true
		_animated_sprite.play("outside_open")

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name != "Controller": return

	print("Requesting inner hatch open!")
	_wallE.set_deferred("disabled", false) # Close outside hitbox
	if outside_open: # If outside is open, close and await the animation
		outside_open = false
		_animated_sprite.play("outside_close")
		await _animated_sprite.animation_finished
	
	_wallW.set_deferred("disabled", true) # Open inside hitbox
	if not inside_open: # If inside is closed, play open animation
		inside_open = true
		_animated_sprite.play("inside_open")
