class_name BattleManager
extends Node2D

var qi: QuestionImporter
var current_question: Question
var current_choices: Array
var question_index_queue: Array
var question_current_index: int

var item_manager: BattleItemsManager

enum Battle_Turn {Player_Turn, Enemy_Turn}
var turn: Battle_Turn

var strength_modifier_turns: int
var homework_turns: int

var enemy_defeated: bool

var player: BattlePlayer
var enemy: Enemy

var battle_ui: Control
var battle_gfx: Node2D

var battle_buttons: Control
var attack_button: Button
var item_button: Button
var question_button: Button

var attack_label: Label
var item_label: Label
var question_attack_label: Label
var enemy_label: Label

var attack_popup: Control
var item_popup: Control
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

var player_hp_label: Label
var enemy_hp_label: Label

var correct_answer: bool

var ui_timer: Timer
var attack_timer: Timer
var question_timer: Timer
var enemy_timer: Timer

func _ready() -> void:
	player = get_node("%Battle_GFX/%Battle_Player")
	enemy = get_node("%Battle_GFX/%Enemy")
	
	battle_ui = get_node("%BattleUI")
	battle_gfx = get_node("%Battle_GFX")
	
	battle_buttons = get_node("%BattleUI/%Battle_Buttons")
	attack_button = get_node("%BattleUI/%Attack_Button")
	item_button = get_node("%BattleUI/%Item_Button")
	question_button = get_node("%BattleUI/%Question_Button")
	
	attack_popup = get_node("%BattleUI/%Attack_Popup")
	attack_label = get_node("%BattleUI/%Attack_Text")
	
	item_popup = get_node("%BattleUI/%Item_Popup")
	item_label = get_node("%BattleUI/%Item_Text")
	
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
	
	player_hp_label = get_node("%BattleUI/%Player_HP")
	enemy_hp_label = get_node("%BattleUI/%Enemy_HP")
	
	ui_timer = get_node("%BattleUI_Anim_Timer")
	attack_timer = get_node("%Attack_Timer")
	question_timer = get_node("%Question_Timer")
	enemy_timer = get_node("%Enemy_Timer")
	
	attack_button.pressed.connect(_on_attack_pressed)
	item_button.pressed.connect(_on_item_pressed)
	question_button.pressed.connect(_on_question_pressed)
	
	button1.pressed.connect(_on_button1_pressed)
	button2.pressed.connect(_on_button2_pressed)
	button3.pressed.connect(_on_button3_pressed)
	button4.pressed.connect(_on_button4_pressed)
	
	ui_timer.timeout.connect(_on_ui_timer_end)
	attack_timer.timeout.connect(_on_attack_timer_end)
	question_timer.timeout.connect(_on_question_timer_end)
	enemy_timer.timeout.connect(_on_enemy_timer_end)
	
	item_manager = get_node("%Item_Manager")
	
	qi = get_node("%Question_Importer")
	qi.read_questions()
	for k in qi.questions.keys():
		question_index_queue.append(k)
	question_current_index = 0

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	player_hp_label.text = str(player.health_points) + "/" + str(player.max_health)
	enemy_hp_label.text = str(enemy.health_points) + "/" + str(enemy.max_health)

# New funck needed to take in door data, to know which scene to show for the battle
# TODO: Take in enemy data  -- Riley 03/31/26 starts on this
func start_battle() -> void:
	battle_ui.visible = true
	battle_gfx.visible = true
	battle_buttons.visible = true
	question_ui.visible = false
	correct_answer = false
	enemy_defeated = false
	turn = Battle_Turn.Player_Turn
	
	var overworld_gfx = get_node("%Overworld_GFX")
	if overworld_gfx:
		overworld_gfx.visible = false
	
	question_index_queue.shuffle()
	question_current_index = 0


func end_battle() -> void:
	battle_ui.visible = false
	battle_gfx.visible = false
	battle_buttons.visible = false
	question_ui.visible = false
	
	var overworld_gfx = get_node("%Overworld_GFX")
	if overworld_gfx:
		overworld_gfx.visible = true


func _on_button1_pressed() -> void:
	if answer_index == 0:
		_on_correct_answer()
		return
	_on_wrong_answer()


func _on_button2_pressed() -> void:
	if answer_index == 1:
		_on_correct_answer()
		return
	_on_wrong_answer()


func _on_button3_pressed() -> void:
	if answer_index == 2:
		_on_correct_answer()
		return
	_on_wrong_answer()


func _on_button4_pressed() -> void:
	if answer_index == 3:
		_on_correct_answer()
		return
	_on_wrong_answer()


func enable_buttons(enable: bool) -> void:
	button1.disabled = !enable
	button2.disabled = !enable
	button3.disabled = !enable
	button4.disabled = !enable


func set_question(question: Question) -> void:
	current_question = question
	var choices = Array()
	choices = [ question.ChoiceA, question.ChoiceB, question.ChoiceC, question.ChoiceD ]
	choices.shuffle()
	
	for i in choices.size():
		var choice = choices[i]
		if choice == question.ChoiceA:
			answer_index = i
	
	current_choices = choices
	
	question_label.text = question.Text
	button1_label.text = choices[0]
	button2_label.text = choices[1]
	button3_label.text = choices[2]
	button4_label.text = choices[3]
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
	player_hp_label.visible = true
	enemy_hp_label.visible = true
	question_ui.visible = false
	
	question_attack_popup.visible = true
	var text: String
	var damage: int
	if correct_answer:
		if strength_modifier_turns <= 0:
			@warning_ignore("narrowing_conversion")
			damage = player.attack_power * player.question_modifier
		else:
			@warning_ignore("narrowing_conversion")
			damage = (player.attack_power * player.question_modifier) * 2
		text = "WHAM!!! %s damage!"
	else:
		@warning_ignore("integer_division")
		damage = player.attack_power / 2
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
	
	var text = "Smash! %s damage!"
	
	if strength_modifier_turns <= 0:
		enemy.health_points -= player.attack_power
		attack_label.text = text % player.attack_power
	# If strength potion effect is active
	else:
		enemy.health_points -= player.attack_power * 3
		attack_label.text = text % str(player.attack_power * 3)
	
	if enemy.health_points < 0:
		enemy.health_points = 0
	
	
	attack_timer.start()


func _on_attack_timer_end() -> void:
	attack_popup.visible = false
	
	if enemy.health_points == 0:
		enemy_defeated = true
	
	# Decrement number of turns left until strength potion wears off
	strength_modifier_turns -= 1
	strength_modifier_turns = clamp(strength_modifier_turns, 0, 999)
	
	# switch to enemy's turn
	turn = Battle_Turn.Enemy_Turn
	enemy_turn()
### Attack ###

### Item ###
func _on_item_pressed() -> void:
	battle_buttons.visible = false
	item_manager.show_items()
### Item ###

### Question ###
func _on_question_pressed() -> void:
	var index = randi_range(0, len(qi.questions)-1)
	var i = 0
	for k in qi.questions.keys():
		if i == index:
			set_question(qi.questions[question_index_queue[question_current_index]])
			question_current_index += 1
		i += 1
	
	battle_buttons.visible = false
	question_ui.visible = true
	player_hp_label.visible = false
	enemy_hp_label.visible = false
	enable_buttons(true)
	
	if homework_turns > 0:
		var incorrect_choices: Array
		for j in current_choices.size():
			if j != answer_index:
				incorrect_choices.append(j)
		
		incorrect_choices.shuffle()
		
		for h in 2:
			var incorrect_index = incorrect_choices[h]
			if incorrect_index == 0:
				button1.disabled = true
			elif incorrect_index == 1:
				button2.disabled = true
			elif incorrect_index == 2:
				button3.disabled = true
			elif incorrect_index == 3:
				button4.disabled = true


func _on_question_timer_end() -> void:
	question_attack_popup.visible = false
	
	# TODO: Player defeat
	if player.health_points == 0:
		pass
	
	if enemy.health_points == 0:
		enemy_defeated = true
	
	# Decrement number of turns left until strength potion wears off
	strength_modifier_turns -= 1
	strength_modifier_turns = clamp(strength_modifier_turns, 0, 999)
	
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
