extends SceneTree

const QUESTION := preload("res://Scripts/Questions/question.gd")
const BATTLE_ENEMY := preload("res://Scripts/enemy.gd")
const BATTLE_PLAYER := preload("res://Scripts/battle_player.gd")
const QUESTION_IMPORTER := preload("res://Scripts/Questions/question_importer.gd")
const BATTLE_MANAGER := preload("res://Scripts/battle_manager.gd")
const BATTLE_ITEMS := preload("res://Scripts/battle_items_manager.gd")


var errors: Array[String] = []

func assert_equal(actual, expected, fail_message: String, success_message: String) -> void:
	if actual != expected:
		print("Test failed!")
		errors.append("%s Expected %s, got %s." % [fail_message, str(expected), str(actual)])
	else:
		print(success_message)

func test_player(health: int, attack: int, question: float) -> Node2D:
	var player := BATTLE_PLAYER.new()
	player.set("health_points", health)
	player.set("attack_power", attack)
	player.set("question_modifier", question)
	return player

func test_enemy(health: int, attack: int) -> Node2D:
	var enemy := BATTLE_ENEMY.new()
	enemy.set("health_points", health)
	enemy.set("attack_power", attack)
	return enemy


func _initialize() -> void:
	call_deferred("test_battle")

func test_battle() -> void:
	take_damage_test()
	question_damage_test()
	deal_damage_test()
	healing_potion_test()
	if errors.is_empty():
		print("Tests passed!")
		quit(0)
	else:
		for e in errors:
			push_error(e)
		quit(1)
		

func take_damage_test() -> void:
	var battle = BATTLE_MANAGER.new()
	battle.player = test_player(20, 3, 3.0)
	battle.enemy = test_enemy(12, 2)
	
	battle.player.health_points -= battle.enemy.attack_power
	if battle.player.health_points < 0:
		battle.player.health_points = 0
	assert_equal(battle.player.health_points, 18, "Enemy turn: player HP should decrease by enemy attack_power", "Taking Damage test successful!")
	
	battle.player.free()
	battle.enemy.free()
	battle.free()

func question_damage_test() -> void:
	var battle = BATTLE_MANAGER.new()
	battle.player = test_player(20, 3, 3.0)
	battle.enemy = test_enemy(12, 2)
	
	battle.enemy.health_points -= battle.player.attack_power * battle.player.question_modifier
	if battle.enemy.health_points < 0:
		battle.enemy.health_points = 0
	assert_equal(battle.enemy.health_points, 3, "Player turn: player answering question should decrease enemy HP by (attack_power*questeion_modifier)", "Question Damage test successful!")
	
	battle.player.free()
	battle.enemy.free()
	battle.free()

func deal_damage_test() -> void:
	var battle = BATTLE_MANAGER.new()
	battle.player = test_player(20, 3, 3.0)
	battle.enemy = test_enemy(12, 2)
	
	battle.enemy.health_points -= battle.player.attack_power
	if battle.enemy.health_points < 0:
		battle.enemy.health_points = 0
	assert_equal(battle.enemy.health_points, 9, "Playr turn: player attacking enemy should decrease enemy HP by attack_power", "Deal Damage test successful!")
	
	battle.player.free()
	battle.enemy.free()
	battle.free()

func healing_potion_test() -> void:
	var root_node = Node.new()
	get_root().add_child(root_node)
	var battle = BATTLE_MANAGER.new()
	var items = BATTLE_ITEMS.new()
	items.item_ui = Control.new()
	items.battle_manager = battle
	items.popup_label = Label.new()
	items.popup_label.text = "test"
	items.popup = Control.new()
	items.popup_timer = Timer.new()
	root_node.add_child(items.popup_timer)
	
	battle.player = test_player(20, 3, 3.0)
	battle.enemy = test_enemy(12, 2)
	
	items._on_health_pressed()
	assert_equal(battle.player.health_points, 40, "Player turn: player using healing potion should increase player HP by 20", "Healing Potion test successful!")
	
	battle.player.free()
	battle.enemy.free()
	battle.free()
	items.popup.free()
	items.popup_label.free()
	items.popup_timer.free()
	items.item_ui.free()
	items.free()
	root_node.queue_free()
	
