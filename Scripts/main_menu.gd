extends Control
var ReturnToMenu: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ReturnToMenu = get_node("Settings/%Return_To_Menu")
	ReturnToMenu.pressed.connect(_on_return_to_menu_pressed)


func _on_options_pressed() -> void:
	get_node("%Settings").visible = true
	get_node("%MainMenuButtons").visible = false


func _on_return_to_menu_pressed() -> void:
	get_node("%MainMenuButtons").visible = true
	get_node("%Settings").visible = false



func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_exit_game_pressed() -> void:
	get_tree().quit()
