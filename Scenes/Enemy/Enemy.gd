extends KinematicBody2D


export(Resource) var health


func _ready():
	health.connect("depleted", self, "queue_free")
