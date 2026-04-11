extends SceneTree

const BATTLE_ENEMY := preload("res://Scripts/enemy.gd")
const BATTLE_PLAYER := preload("res://Scripts/battle_player.gd")
const BATTLE_MANAGER := preload("res://Scripts/battle_manager.gd")

var errors: Array[String] = []

func assert_equal(actual, expected, message: String) -> void:
	if actual != expected:
		errors.append("%s Expected %s, got %s." % [message, str(expected), str(actual)])

func test_player(health: int, attack: int, defense: int, question: float) -> Node2D:
	var player := BATTLE_PLAYER.new()
	player.set("health_points", health)
	player.set("attack_power", attack)
	player.set("defense_power", defense)
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
	if errors.is_empty():
		print("Tests passed!")
		quit(0)
	else:
		for e in errors:
			push_error(e)
		quit(1)
		

func take_damage_test() -> void:
	var battle = BATTLE_MANAGER.new()
	battle.player = test_player(20, 3, 2, 3.0)
	battle.enemy = test_enemy(12, 2)
	
	battle.player.health_points -= battle.enemy.attack_power
	if battle.player.health_points < 0:
		battle.player.health_points = 0
	assert_equal(battle.player.health_points, 18, "Enemy turn: player HP should decrease by enemy attack_power")
	
	battle.player.free()
	battle.enemy.free()
	battle.free()
