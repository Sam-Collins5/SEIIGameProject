extends Control
var Options: Button
var ReturnToMenu: Button
var Continue: Button
var ExitGame: Button
var is_paused: bool
var esc_pressed: bool
signal pause_toggle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_paused = false
	esc_pressed = false
	Options = get_node("%Options")
	Options.pressed.connect(_on_options_pressed)
	ReturnToMenu = get_node("%Settings/%Return_To_Menu")
	ReturnToMenu.pressed.connect(_on_return_to_menu_pressed)
	pause_toggle.connect(get_node("%GameManager")._pause_toggle)
	Continue = get_node("%ContinueGame")
	Continue.pressed.connect(_on_continue_pressed)
	ExitGame = get_node("%BackToMainMenu")
	ExitGame.pressed.connect(_on_back_to_main_menu_pressed)

func _process(delta) -> void:
	if Input.is_action_pressed("pause") && !esc_pressed:
		print("HELP ME PLEASE WHY")
		is_paused = !is_paused
		esc_pressed = true
		get_node("%Settings").visible = false
		get_node("%Overworld_GFX").visible = true
		get_node("%PauseMenu").visible = is_paused
		pause_toggle.emit()
	if Input.is_action_just_released("pause"):
		esc_pressed = false

func _on_options_pressed() -> void:
	get_node("%Settings").visible = true
	get_node("%PauseMenu").visible = false
	get_node("%Overworld_GFX").visible = false

func _on_continue_pressed() -> void:
	get_node("%Settings").visible = false
	get_node("%PauseMenu").visible = false
	get_node("%Overworld_GFX").visible = true
	is_paused = !is_paused

func _on_return_to_menu_pressed() -> void:
	get_node("%Overworld_GFX").visible = true
	get_node("%PauseMenu").visible = true
	get_node("%Settings").visible = false



func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back_to_main_menu_pressed() -> void:
	get_node("%GameManager").switch_to_title_screen()
