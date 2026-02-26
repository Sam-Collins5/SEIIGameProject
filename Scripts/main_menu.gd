extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://settings.tscn") # Replace with function body.



func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_exit_game_pressed() -> void:
	get_tree().quit()
