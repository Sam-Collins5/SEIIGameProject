class_name BattleManager
extends Node2D

enum Battle_Turn {Player_Turn, Enemy_Turn}
var turn: Battle_Turn

var enemy_defeated: bool

var player: Node2D
var enemy: Node2D

var battle_ui: Control
var battle_gfx: Node2D

var battle_buttons: Control
var attack_button: Button
var defend_button: Button
var question_button: Button

var attack_label: Label
var defend_label: Label
var question_attack_label: Label
var enemy_label: Label

var attack_popup: Control
var defend_popup: Control
var question_attack_popup: Control
var enemy_popup: Control

var question_ui: Control

var wrong_answer_ui: Control
var correct_answer_ui: Control

var question_label: Label
var answer_index: int
var button1: Button
var button2: Button
var button3: Button
var button4: Button
var button1_label: Label
var button2_label: Label
var button3_label: Label
var button4_label: Label

var correct_answer: bool

var ui_timer: Timer
var attack_timer: Timer
var defend_timer: Timer
var question_timer: Timer
var enemy_timer: Timer

func _ready() -> void:
	player = get_node("%Battle_GFX/%Battle_Player")
	enemy = get_node("%Battle_GFX/%Enemy")
	
	battle_ui = get_node("%BattleUI")
	battle_gfx = get_node("%Battle_GFX")
	
	battle_buttons = get_node("%BattleUI/%Battle_Buttons")
	attack_button = get_node("%BattleUI/%Attack_Button")
	defend_button = get_node("%BattleUI/%Defend_Button")
	question_button = get_node("%BattleUI/%Question_Button")
	
	attack_popup = get_node("%BattleUI/%Attack_Popup")
	attack_label = get_node("%BattleUI/%Attack_Text")
	
	defend_popup = get_node("%BattleUI/%Defend_Popup")
	defend_label = get_node("%BattleUI/%Defend_Text")
	
	question_attack_popup = get_node("%BattleUI/%Question_Popup")
	question_attack_label = get_node("%BattleUI/%Question_Attack_Text")
	
	enemy_popup = get_node("%BattleUI/%Enemy_Popup")
	enemy_label = get_node("%BattleUI/%Enemy_Text")
	
	question_ui = get_node("%BattleUI/%Question_UI")
	
	wrong_answer_ui = get_node("%BattleUI/%WrongAnswer_BG")
	correct_answer_ui = get_node("%BattleUI/%CorrectAnswer_BG")
	
	question_label = get_node("%BattleUI/%Question_Label")
	
	button1 = get_node("%BattleUI/%Button1")
	button2 = get_node("%BattleUI/%Button2")
	button3 = get_node("%BattleUI/%Button3")
	button4 = get_node("%BattleUI/%Button4")
	button1_label = get_node("%BattleUI/%Button1Label")
	button2_label = get_node("%BattleUI/%Button2Label")
	button3_label = get_node("%BattleUI/%Button3Label")
	button4_label = get_node("%BattleUI/%Button4Label")
	
	ui_timer = get_node("%BattleUI_Anim_Timer")
	attack_timer = get_node("%Attack_Timer")
	defend_timer = get_node("%Defend_Timer")
	question_timer = get_node("%Question_Timer")
	enemy_timer = get_node("%Enemy_Timer")
	
	attack_button.pressed.connect(_on_attack_pressed)
	defend_button.pressed.connect(_on_defend_pressed)
	question_button.pressed.connect(_on_question_pressed)
	
	button1.pressed.connect(_on_button1_pressed)
	button2.pressed.connect(_on_button2_pressed)
	button3.pressed.connect(_on_button3_pressed)
	button4.pressed.connect(_on_button4_pressed)
	
	ui_timer.timeout.connect(_on_ui_timer_end)
	attack_timer.timeout.connect(_on_attack_timer_end)
	defend_timer.timeout.connect(_on_defend_timer_end)
	question_timer.timeout.connect(_on_question_timer_end)
	enemy_timer.timeout.connect(_on_enemy_timer_end)
	
	var question_data: Array
	question_data.append("What's 9+10?")
	question_data.append("21")
	question_data.append("24")
	question_data.append("19")
	question_data.append("7")
	question_data.append(3)
	set_question(question_data)
	
	# TEMP
	start_battle()
	# TEMP


# TODO: Take in enemy data
func start_battle() -> void:
	battle_ui.visible = true
	battle_gfx.visible = true
	battle_buttons.visible = true
	question_ui.visible = false
	correct_answer = false
	enemy_defeated = false
	turn = Battle_Turn.Player_Turn


func end_battle() -> void:
	battle_ui.visible = false
	battle_gfx.visible = false
	battle_buttons.visible = false
	question_ui.visible = false


func _on_button1_pressed() -> void:
	if answer_index == 1:
		_on_correct_answer()
		return
	_on_wrong_answer()


func _on_button2_pressed() -> void:
	if answer_index == 2:
		_on_correct_answer()
		return
	_on_wrong_answer()


func _on_button3_pressed() -> void:
	if answer_index == 3:
		_on_correct_answer()
		return
	_on_wrong_answer()


func _on_button4_pressed() -> void:
	if answer_index == 4:
		_on_correct_answer()
		return
	_on_wrong_answer()


func enable_buttons(enable: bool) -> void:
	button1.disabled = !enable
	button2.disabled = !enable
	button3.disabled = !enable
	button4.disabled = !enable


func set_question(question_data: Array) -> void:
	if question_data.size() != 6:
		push_error("Question data array has incorrect size!")
		return
	question_label.text = question_data[0]
	button1_label.text = question_data[1]
	button2_label.text = question_data[2]
	button3_label.text = question_data[3]
	button4_label.text = question_data[4]
	answer_index = question_data[5]
	enable_buttons(true)


func _on_wrong_answer() -> void:
	wrong_answer_ui.visible = true
	enable_buttons(false)
	correct_answer = false
	ui_timer.start()


func _on_correct_answer() -> void:
	correct_answer_ui.visible = true
	enable_buttons(false)
	correct_answer = true
	ui_timer.start()


func _on_ui_timer_end() -> void:
	wrong_answer_ui.visible = false
	correct_answer_ui.visible = false
	question_ui.visible = false
	
	question_attack_popup.visible = true
	var text: String
	var damage: int
	if correct_answer:
		damage = player.attack_power * player.question_modifier
		text = "WHAM!!! %s damage!"
	else:
		damage = player.attack_power / 2.0
		text = "Wrong! %s damage..."
	
	enemy.health_points -= damage
	if enemy.health_points < 0:
		enemy.health_points = 0
	
	question_attack_label.text = text % damage
	
	# Timer to display question damage
	question_timer.start()


### Attack ###
func _on_attack_pressed() -> void:
	battle_buttons.visible = false
	attack_popup.visible = true
	
	enemy.health_points -= player.attack_power
	if enemy.health_points < 0:
		enemy.health_points = 0
	
	var text = "Smash! %s damage!"
	attack_label.text = text % player.attack_power
	
	attack_timer.start()


func _on_attack_timer_end() -> void:
	attack_popup.visible = false
	
	if enemy.health_points == 0:
		enemy_defeated = true
	
	# switch to enemy's turn
	turn = Battle_Turn.Enemy_Turn
	enemy_turn()
### Attack ###

### Defend ###
func _on_defend_pressed() -> void:
	battle_buttons.visible = false
	defend_popup.visible = true
	
	var damage = round(enemy.attack_power / player.defense_power)
	if damage < 1:
		damage = 1
	player.health_points -= damage
	if player.health_points < 0:
		player.health_points = 0
	
	var text = "Deflected the hit! You took %s damage!"
	defend_label.text = text % damage
	
	defend_timer.start()

func _on_defend_timer_end() -> void:
	defend_popup.visible = false
	battle_buttons.visible = true
	
	# TODO: Player defeat
	if player.health_points == 0:
		pass
	
	if enemy.health_points == 0:
		enemy_defeated = true
### Defend ###

### Question ###
func _on_question_pressed() -> void:
	battle_buttons.visible = false
	question_ui.visible = true
	enable_buttons(true)

func _on_question_timer_end() -> void:
	question_attack_popup.visible = false
	
	# TODO: Player defeat
	if player.health_points == 0:
		pass
	
	if enemy.health_points == 0:
		enemy_defeated = true
	
	# switch to enemy's turn
	turn = Battle_Turn.Enemy_Turn
	enemy_turn()
### Question ###

### Enemy ###
func enemy_turn() -> void:
	enemy_popup.visible = true
	
	if enemy_defeated:
		enemy_label.text = "Enemy defeated!"
		enemy_timer.start()
		return
	
	player.health_points -= enemy.attack_power
	if player.health_points < 0:
		player.health_points = 0
	
	var text = "Ouch! You took %s damage!"
	enemy_label.text = text % enemy.attack_power
	
	# TODO: Player defeat
	if player.health_points == 0:
		pass
	enemy_timer.start()

func _on_enemy_timer_end() -> void:
	# switch to player's turn
	enemy_popup.visible = false
	if enemy_defeated:
		end_battle()
		return
	battle_buttons.visible = true
	turn = Battle_Turn.Player_Turn
### Enemy ###
