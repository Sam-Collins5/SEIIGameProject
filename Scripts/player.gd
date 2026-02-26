extends CharacterBody2D
signal collide
@export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func get_input():
	var input_direction = Vector2.ZERO
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	#print(velocity)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if velocity.x != 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "walk_horiz"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y > 0 && velocity.x == 0:
		$AnimatedSprite2D.animation = "walk_down"
	if velocity.y < 0 && velocity.x == 0:
		$AnimatedSprite2D.animation = "walk_up"
	if velocity.y < 0 && velocity.x > 0:
		$AnimatedSprite2D.animation = "walk_updiag"
		$AnimatedSprite2D.flip_h = false
	if velocity.y < 0 && velocity.x < 0:
		$AnimatedSprite2D.animation = "walk_updiag"
		$AnimatedSprite2D.flip_h = true
	if velocity.y > 0 && velocity.x > 0:
		$AnimatedSprite2D.animation = "walk_downdiag"
		$AnimatedSprite2D.flip_h = false
	if velocity.y > 0 && velocity.x < 0:
		$AnimatedSprite2D.animation = "walk_downdiag"
		$AnimatedSprite2D.flip_h = true
		




func _physics_process(delta):
	get_input()
	move_and_slide()
	
	
	
	
func _process(delta):
	if Input.is_key_pressed(KEY_B):
		var game_manager = get_node("%GameManager")
		game_manager.switch_to_battle()
	
	


func _on_body_entered(body: Node2D) -> void:
	collide.emit()
	
