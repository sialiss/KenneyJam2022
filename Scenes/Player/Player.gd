extends KinematicBody2D


var velocity = Vector2.ZERO
var max_speed = 16*10
var acceleration_time = 0.1
var acceleration = max_speed / acceleration_time
var deceleration_time = 0.3
var deceleration = max_speed / deceleration_time
var gravity = 16*30 / 1
var jump_speed = 16*15

var under_max_speed = 16*15
var under_acceleration_time = 0.1
var under_acceleration = max_speed / under_acceleration_time
var under_deceleration_time = 0.1
var under_deceleration = max_speed / under_deceleration_time

var burrow_speed = 16*10
var unburrow_speed = 16*10


export(int, LAYERS_2D_PHYSICS) var collision_mask_normal = 0
export(int, LAYERS_2D_PHYSICS) var collision_mask_burrow = 0

export(PackedScene) var SpawnFlowersSpellScene
export(PackedScene) var AttackSpellScene

onready var UndergroundSurfaceDetector = $"%UndergroundSurfaceDetector"
onready var OvergroundSurfaceDetector = $"%OvergroundSurfaceDetector"
onready var PlayerSprite = $Sprite
onready var AnimTree = $AnimationTree
onready var FlowerSeedTimer = $FlowerSeedTimer
onready var Crosshair = $"%Crosshair"

onready var Playback: AnimationNodeStateMachinePlayback = AnimTree.get("parameters/playback")

export(Resource) var health
export(Resource) var mana


func _ready():
	OvergroundStatus.new().attach(self)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	FlowerSeedTimer.connect("timeout", self, "spawn_flowers")

func _exit_tree():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	Crosshair.global_position = get_global_mouse_position()
	Crosshair.global_rotation = lerp_angle(Crosshair.global_rotation, self.get_angle_to(Crosshair.global_position), 20*delta)


func _physics_process(delta):
	match sign(velocity.x):
		00.0: pass
		-1.0: PlayerSprite.flip_h = true
		+1.0: PlayerSprite.flip_h = false


func cast_spells():
	if Input.is_action_just_pressed("cast_primary"):
		var attack_spell = AttackSpellScene.instance()
		attack_spell.global_position = global_position
		attack_spell.apply_central_impulse(global_position.direction_to(Crosshair.global_position) * 300)
		Spawner.spawn(attack_spell)


func spawn_flowers():
	var spawn_flowers_spell = SpawnFlowersSpellScene.instance()
	spawn_flowers_spell.global_position = global_position
	Spawner.spawn(spawn_flowers_spell)

func start_flower_timer():
	if FlowerSeedTimer.is_stopped():
		FlowerSeedTimer.start()

func stop_flower_timer():
	FlowerSeedTimer.stop()


class OvergroundStatus extends Status:
	func _ready():
		host.start_flower_timer()

	func _physics_process(delta):
		# Gravity
		host.velocity.y += host.gravity * delta

		# Movement
		var input = Input.get_axis("move_left", "move_right")
		if input != 0:
			host.velocity.x = move_toward(host.velocity.x, input * host.max_speed, host.acceleration * delta)
			host.Playback.travel("walk")
		else:
			host.velocity.x = move_toward(host.velocity.x, 0, host.deceleration * delta)
			host.Playback.travel("idle")

		host.velocity = host.move_and_slide_with_snap(host.velocity, Vector2.DOWN, Vector2.UP)

		host.cast_spells()

		if Input.is_action_just_pressed("jump") and host.is_on_floor():
			host.velocity.y -= host.jump_speed
			JumpStatus.new().attach(host)

		elif Input.is_action_just_pressed("burrow"):
			DigDown.new().attach(host)


class JumpStatus extends Status:
	func _ready():
		host.start_flower_timer()
		host.Playback.travel("jump")

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

		host.cast_spells()

		if host.is_on_floor():
			OvergroundStatus.new().attach(host)

		elif Input.is_action_just_pressed("burrow"):
			DigDown.new().attach(host)


class UndergroundStatus extends Status:
	func _ready():
		host.stop_flower_timer()
		host.Playback.travel("idle underground")

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
		host.stop_flower_timer()
		host.collision_mask = host.collision_mask_burrow
		host.Playback.travel("dive")

	func _physics_process(delta):
		# Gravity
		host.velocity.y = move_toward(host.velocity.y, host.burrow_speed, host.gravity * delta)

		# Movement
		var input = Input.get_axis("move_left", "move_right")
		if input != 0:
			host.velocity.x = move_toward(host.velocity.x, input * host.max_speed, host.acceleration * delta)
		else:
			host.velocity.x = move_toward(host.velocity.x, 0, host.deceleration * delta)

		host.velocity = host.move_and_slide(host.velocity, Vector2.UP)

		if host.UndergroundSurfaceDetector.get_overlapping_bodies().size():
			UndergroundStatus.new().attach(host)

class DigUp extends Status:
	func _ready():
		host.stop_flower_timer()
		host.Playback.travel("redive")

	func _physics_process(delta):
		# Gravity
		host.velocity.y = move_toward(host.velocity.y, -host.unburrow_speed, host.gravity * delta)

		# Movement
		var input = Input.get_axis("move_left", "move_right")
		if input != 0:
			host.velocity.x = move_toward(host.velocity.x, input * host.max_speed, host.acceleration * delta)
		else:
			host.velocity.x = move_toward(host.velocity.x, 0, host.deceleration * delta)

		host.velocity = host.move_and_slide(host.velocity, Vector2.UP)

		if not host.OvergroundSurfaceDetector.get_overlapping_bodies().size():
			JumpStatus.new().attach(host)
			host.collision_mask = host.collision_mask_normal
