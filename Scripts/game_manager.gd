class_name GameManager
extends Node2D

enum GameState {TITLE_SCREEN, OVERWORLD, BATTLE}
var game_state: GameState

@export var overworldPlayer: Node2D
@export var battlePlayer: Node2D

func _ready() -> void:
	# TODO: Get overworld and battle player objects
	pass

func switch_to_title_screen() -> void:
	# Switch to title screen scene
	# TODO: (Joshua B.) Uncomment these lines and put in title screen scene path
	#var title_scene = preload("res://title_scene_name").instantiate()
	#get_tree().root().add_child(title_scene)
	game_state = GameState.TITLE_SCREEN

func switch_to_overworld() -> void:
	# If coming from title screen,
	#  switch to an overworld scene
	if game_state == GameState.TITLE_SCREEN:
		pass
	# If coming from battle, disable
	#  battle graphics
	elif game_state == GameState.BATTLE:
		pass
	game_state = GameState.OVERWORLD

func switch_to_battle() -> void:
	# Enable battle graphics
	game_state = GameState.BATTLE

func state_switch(state: GameState) -> void:
	if state == GameState.TITLE_SCREEN:
		switch_to_title_screen()
	elif state == GameState.OVERWORLD:
		switch_to_overworld()
	elif state == GameState.BATTLE:
		switch_to_battle()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
