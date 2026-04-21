class_name BattleItemsManager
extends Node

var battle_manager: Node

var item_ui: Control

var homework_button: Button
var health_potion_button: Button
var strength_potion_button: Button
var back_button: Button

var homework_label: Label
var health_potion_label: Label
var strength_potion_label: Label

var popup: Control
var popup_label: Label

var popup_timer: Timer

enum Item_Type {Health, Homework, Strength}
var item_used: Item_Type

func _ready() -> void:
	battle_manager = get_node("../%BattleManager")
	
	item_ui = get_node("../%BattleUI/%Item_UI")
	
	homework_button = get_node("../%BattleUI/%Item_UI/%Homework_Button")
	health_potion_button = get_node("../%BattleUI/%Item_UI/%Health_Potion_Button")
	strength_potion_button = get_node("../%BattleUI/%Item_UI/%Strength_Potion_Button")
	back_button = get_node("../%BattleUI/%Item_UI/%Back_Button")
	
	homework_label = get_node("../%BattleUI/%Item_UI/%Homework_Button/Amount")
	health_potion_label = get_node("../%BattleUI/%Item_UI/%Health_Potion_Button/Amount")
	strength_potion_label = get_node("../%BattleUI/%Item_UI/%Strength_Potion_Button/Amount")
	
	popup = get_node("../%BattleUI/%Item_Popup")
	popup_label = get_node("../%BattleUI/%Item_Popup/%Item_Text")
	
	popup_timer = get_node("%Popup_Timer")
	
	homework_button.pressed.connect(_on_homework_pressed)
	health_potion_button.pressed.connect(_on_health_pressed)
	strength_potion_button.pressed.connect(_on_strength_pressed)
	back_button.pressed.connect(_on_back_pressed)
	
	popup_timer.timeout.connect(_on_popup_timer_end)
	
	item_ui.visible = false

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	var player = battle_manager.player
	health_potion_label.text = "x" + str(player.health_potions)
	homework_label.text = "x" + str(player.homeworks)
	strength_potion_label.text = "x" + str(player.strength_potions)

func show_items() -> void:
	item_ui.visible = true


func _on_homework_pressed() -> void:
	var player = battle_manager.player
	
	if player.homeworks <= 0:
		return
		
	item_used = Item_Type.Homework
	
	item_ui.visible = false
	player.homeworks -= 1
	player.homeworks = clamp(player.homeworks, 0, 999)
	
	battle_manager.homework_turns += 1
	battle_manager.homework_turns = clamp(battle_manager.homework_turns, 0, 999)
	
	battle_manager._on_question_pressed()

func _on_health_pressed() -> void:
	var player = battle_manager.player
	
	if player.health_potions <= 0:
		return
	
	item_used = Item_Type.Health
	
	item_ui.visible = false
	popup_label.text = "Healed 20 HP!"
	popup.visible = true
	
	player.health_points += 20
	player.health_points = clamp(player.health_points, 0, player.max_health)
	
	player.health_potions -= 1
	player.health_potions = clamp(player.health_potions, 0, 999)
	
	popup_timer.start()


func _on_strength_pressed() -> void:
	var player = battle_manager.player
	
	if player.strength_potions <= 0:
		return
	
	item_used = Item_Type.Strength
	
	item_ui.visible = false
	popup_label.text = "Fired up! Strength increased!"
	popup.visible = true
	
	player.strength_potions -= 1
	player.strength_potions = clamp(player.strength_potions, 0, 999)
	
	battle_manager.strength_modifier_turns += 2
	battle_manager.strength_modifier_turns = clamp(battle_manager.strength_modifier_turns, 0, 999)
	
	popup_timer.start()


func _on_back_pressed() -> void:
	item_ui.visible = false
	battle_manager.battle_buttons.visible = true


func _on_popup_timer_end() -> void:
	popup.visible = false
	popup_label.text = ""
	
	item_ui.visible = false
	battle_manager.battle_buttons.visible = true
	
	if item_used != Item_Type.Strength:
		# Decrement number of turns left until strength potion wears off
		battle_manager.strength_modifier_turns -= 1
		battle_manager.strength_modifier_turns = clamp(battle_manager.strength_modifier_turns, 0, 999)
	
	if item_used != Item_Type.Homework:
		battle_manager.turn = battle_manager.Battle_Turn.Enemy_Turn
		battle_manager.enemy_turn()
