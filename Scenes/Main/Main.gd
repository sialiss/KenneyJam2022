extends Node2D

var menu_scene = load("res://Scenes/Menu/Menu.tscn")

func _ready():
	$Music.play()

func _on_MenuButton_pressed():
	$Music.stop()
	get_tree().change_scene_to(menu_scene)
