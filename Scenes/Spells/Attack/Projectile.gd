extends RigidBody2D

export(float) var damage = 1.0


func _ready():
	$TimeLimit.connect("timeout", self, "destroy")
	self.connect("body_entered", self, "on_collision")


func destroy():
	$TimeLimit.stop()
	$AnimationPlayer.play("destroy")


func on_collision(body):
	if "health" in body:
		body.health.value -= damage
	destroy()
