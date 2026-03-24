extends Control
var ReturnToMenu: Button
var FullScreen: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ReturnToMenu = get_node("Settings/%Return_To_Menu")
	ReturnToMenu.pressed.connect(_on_return_to_menu_pressed)
	FullScreen = get_node("Settings/%Full_Screen")
	FullScreen.pressed.connect(_on_full_screen_toggled)


func _on_options_pressed() -> void:
	get_node("%Settings").visible = true
	get_node("%MainMenuButtons").visible = false


func _on_return_to_menu_pressed() -> void:
	get_node("%MainMenuButtons").visible = true
	get_node("%Settings").visible = false



func _on_full_screen_toggled() -> void:
	var window_mode = DisplayServer.window_get_mode()
	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_exit_game_pressed() -> void:
	get_tree().quit()
