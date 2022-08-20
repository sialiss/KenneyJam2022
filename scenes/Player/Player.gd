extends KinematicBody2D


var velocity = Vector2.ZERO
var max_speed = 16*5
var acceleration_time = 0.05
var acceleration = max_speed / acceleration_time
var deceleration_time = 0.3
var deceleration = max_speed / deceleration_time
var gravity = 16*4 / 0.5

func _physics_process(delta):
	# Gravity
	velocity.y += gravity

	# Movement
	var input = Input.get_axis("move_left", "move_right")
	if input != 0:
		velocity.x = move_toward(velocity.x, input * max_speed, acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration*delta)

	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
