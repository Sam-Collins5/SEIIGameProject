class_name GameManager
extends Node2D

enum GameState {TITLE_SCREEN, OVERWORLD, BATTLE}
var game_state: GameState

# TODO: Get overworld and battle player objects

var battleManager: Node2D

var overworldPlayer: Node2D
var battlePlayer: Node2D

var mainMenuStartButton: Button
var mainMenuOptionsButton: Button
var mainMenuExitButton: Button

func _ready() -> void:
	battleManager = get_node("%BattleManager")
	
	if get_tree().root.get_child(0).name == "MainMenu":
		game_state = GameState.TITLE_SCREEN
		init_main_menu()
	elif get_tree().root.get_child(0).name != "Overworld":
		game_state = GameState.OVERWORLD

func init_main_menu() -> void:
	mainMenuStartButton = get_node("%MainMenuButtons/Start Game")
	mainMenuStartButton.pressed.connect(start_game)
	
	mainMenuOptionsButton = get_node("%MainMenuButtons/Options")
	#mainMenuOptionsButton.pressed.connect()
	
	mainMenuExitButton = get_node("%MainMenuButtons/Exit Game")
	mainMenuExitButton.pressed.connect(exit_game)

func start_game() -> void:
	switch_to_overworld()

func exit_game() -> void:
	get_tree().quit()

func switch_to_title_screen() -> void:
	# Switch to title screen scene
	# If mainmenu not loaded
	if get_tree().root.get_child(0).name != "MainMenu":
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	
	game_state = GameState.TITLE_SCREEN

func switch_to_overworld() -> void:
	# If coming from title screen,
	#  switch to an overworld scene
	if game_state == GameState.TITLE_SCREEN:
		print("wowee")
		get_tree().change_scene_to_file("res://Scenes/player.tscn")
	# If coming from battle, disable battle graphics
	elif game_state == GameState.BATTLE:
		battleManager.end_battle()
	game_state = GameState.OVERWORLD

func switch_to_battle() -> void:
	# Enable battle graphics
	game_state = GameState.BATTLE
	battleManager.start_battle()

func state_switch(state: GameState) -> void:
	if state == GameState.TITLE_SCREEN:
		switch_to_title_screen()
	elif state == GameState.OVERWORLD:
		switch_to_overworld()
	elif state == GameState.BATTLE:
		switch_to_battle()
