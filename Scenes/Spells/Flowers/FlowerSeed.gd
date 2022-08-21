extends RigidBody2D

export(PackedScene) var FlowersScene

func _ready():
	$TimeLimit.connect("timeout", self, "queue_free")

func _physics_process(delta):
	var colliding_bodies = get_colliding_bodies()
	if colliding_bodies.size() and $FloorRay.is_colliding() and $FloorRay.get_collision_normal().is_equal_approx(Vector2.UP):
		var flowers = FlowersScene.instance()

		# Snap flower to grid
		var pos = $FloorRay.get_collision_point()
		pos.y = stepify(pos.y, 16)
		pos.x = floor(pos.x / 16) * 16 + 8
		flowers.global_position = pos

		Spawner.spawn(flowers)
		set_physics_process(false)
		queue_free()
