extends CanvasLayer
signal go_to_menu

func _on_Menu_pressed():
	emit_signal("go_to_menu")

func _on_LinkButton_pressed():
	OS.shell_open("https://github.com/sialiss/KenneyJam2022")

func _on_Camellia_pressed():
	OS.shell_open("https://github.com/sialiss")


func _on_Kenney_pressed():
	OS.shell_open("https://kenney.nl/assets")
