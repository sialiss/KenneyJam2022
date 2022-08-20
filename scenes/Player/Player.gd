extends KinematicBody2D


var velocity = Vector2.ZERO
var max_speed = 16*10
var acceleration_time = 0.05
var acceleration = max_speed / acceleration_time
var deceleration_time = 0.3
var deceleration = max_speed / deceleration_time
var gravity = 16*60 / 1

var under_max_speed = 16*12
var under_acceleration_time = 0.05
var under_acceleration = max_speed / under_acceleration_time
var under_deceleration_time = 0.1
var under_deceleration = max_speed / under_deceleration_time


onready var UndergroundSurfaceDetector = $"%UndergroundSurfaceDetector"
onready var OvergroundSurfaceDetector = $"%OvergroundSurfaceDetector"


func _ready():
	OvergroundStatus.new().attach(self)


class OvergroundStatus extends Status:
	func _physics_process(delta):
		# Gravity
		host.velocity.y += host.gravity * delta

		# Movement
		var input = Input.get_axis("move_left", "move_right")
		if input != 0:
			host.velocity.x = move_toward(host.velocity.x, input * host.max_speed, host.acceleration * delta)
		else:
			host.velocity.x = move_toward(host.velocity.x, 0, host.deceleration * delta)

		host.velocity = host.move_and_slide_with_snap(host.velocity, Vector2.DOWN, Vector2.UP)


		if Input.is_action_just_pressed("move_down"):
			DigDown.new().attach(host)


class UndergroundStatus extends Status:
	func _physics_process(delta):
		# Movement
		var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if input.length_squared() != 0:
			host.velocity = host.velocity.move_toward(input * host.under_max_speed, host.under_acceleration * delta)
		else:
			host.velocity = host.velocity.move_toward(Vector2.ZERO, host.under_deceleration * delta)

		host.velocity = host.move_and_slide(host.velocity, Vector2.UP)

		if not host.UndergroundSurfaceDetector.get_overlapping_bodies().size():
			DigUp.new().attach(host)


class DigDown extends Status:
	func _ready():
		host.collision_mask = 0

	func _physics_process(delta):
		# Gravity
		host.velocity.y += host.gravity * delta

		host.velocity = host.move_and_slide(host.velocity, Vector2.UP)

		if host.UndergroundSurfaceDetector.get_overlapping_bodies().size():
			UndergroundStatus.new().attach(host)

class DigUp extends Status:
	func _physics_process(delta):
		# Gravity
		host.velocity.y -= host.gravity * delta

		host.velocity = host.move_and_slide(host.velocity, Vector2.UP)

		if not host.OvergroundSurfaceDetector.get_overlapping_bodies().size():
			OvergroundStatus.new().attach(host)
			host.collision_mask = 1
