extends Node2D

export(int) var amount = 1
export(PackedScene) var FlowerSeedScene

var seeds = []
export(float, 0, 90) var max_angle_degrees = 0.0
export var min_force = 0.0
export var max_force = 0.0

func _ready():
	var max_angle = deg2rad(max_angle_degrees)

	for i in amount:
		var flower_seed = FlowerSeedScene.instance()
		var direction = Vector2.UP.rotated(rand_range(-max_angle, max_angle)) * rand_range(min_force, max_force)

		flower_seed.global_position = global_position
		flower_seed.apply_central_impulse(direction)
		Spawner.spawn(flower_seed)

	queue_free()
