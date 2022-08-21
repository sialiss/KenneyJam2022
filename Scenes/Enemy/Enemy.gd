extends KinematicBody2D
class_name Enemy


export(Resource) var health


func _ready():
	health.connect("depleted", self, "queue_free")
