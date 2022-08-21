extends Enemy


export(PackedScene) var AttackSpellScene


var start_position = Vector2.ZERO
onready var offset = randf()*10000


var target: Node2D


func _ready():
	start_position = global_position
	target = get_tree().get_nodes_in_group("player")[0]
	$AttackTimer.connect("timeout", self, "attack")


func _physics_process(delta):
	var pos = start_position + Vector2(0, 8*sin((Time.get_ticks_msec()+offset)/1000.0))
	move_and_slide(pos - global_position)


func attack():
	if target and is_instance_valid(target):
		var attack_spell = AttackSpellScene.instance()
		attack_spell.global_position = global_position
		attack_spell.apply_central_impulse(global_position.direction_to(target.global_position) * 200)
		Spawner.spawn(attack_spell)
