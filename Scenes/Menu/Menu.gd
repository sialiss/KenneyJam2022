extends CanvasLayer

var game_scene = load("res://Scenes/Main/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# $MenuMusic.play()
	$Credits.hide()

func show_message(text):
	$Message.text = text
	$Message.show()

func _on_StartButton_pressed():
	get_tree().change_scene_to(game_scene)

func _on_CreditsButton_pressed():
	$Credits.show()

func _on_Credits_go_to_menu():
	$Credits.hide()
