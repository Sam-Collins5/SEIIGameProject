extends CharacterBody2D
signal interact
@export var speed = 400
var screen_size
var activebody


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size 

func change_interactable(velocity):
	if velocity.x > 0:
		$InteractBodyRight.show()
		$InteractBodyLeft.hide()
		$InteractBodyDown.hide()
		$InteractBodyUp.hide()
	if velocity.x < 0:
		$InteractBodyRight.hide()
		$InteractBodyLeft.show()
		$InteractBodyDown.hide()
		$InteractBodyUp.hide()
	if velocity.x == 0:
		if velocity.y > 0:
			$InteractBodyRight.hide()
			$InteractBodyLeft.hide()
			$InteractBodyDown.show()
			$InteractBodyUp.hide()
		if velocity.y < 0:
			$InteractBodyRight.hide()
			$InteractBodyLeft.hide()
			$InteractBodyDown.hide()
			$InteractBodyUp.show()

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
	
	if velocity.x > 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "walk_horiz"
		$AnimatedSprite2D.flip_h = false
		change_interactable(velocity)
	if velocity.x < 0 && velocity.y == 0:
		$AnimatedSprite2D.animation = "walk_horiz"
		$AnimatedSprite2D.flip_h = true
		change_interactable(velocity)
	if velocity.y > 0 && velocity.x == 0:
		$AnimatedSprite2D.animation = "walk_down"
		change_interactable(velocity)
	if velocity.y < 0 && velocity.x == 0:
		$AnimatedSprite2D.animation = "walk_up"
		change_interactable(velocity)
	if velocity.y < 0 && velocity.x > 0:
		$AnimatedSprite2D.animation = "walk_updiag"
		$AnimatedSprite2D.flip_h = false
		change_interactable(velocity)
	if velocity.y < 0 && velocity.x < 0:
		$AnimatedSprite2D.animation = "walk_updiag"
		$AnimatedSprite2D.flip_h = true
		change_interactable(velocity)
	if velocity.y > 0 && velocity.x > 0:
		$AnimatedSprite2D.animation = "walk_downdiag"
		$AnimatedSprite2D.flip_h = false
		change_interactable(velocity)
	if velocity.y > 0 && velocity.x < 0:
		$AnimatedSprite2D.animation = "walk_downdiag"
		$AnimatedSprite2D.flip_h = true
		change_interactable(velocity)
	if velocity.x > 0:
		activebody = $InteractBodyRight
	elif velocity.x < 0:
		activebody = $InteractBodyLeft
	elif velocity.y > 0:
		activebody = $InteractBodyDown
	elif velocity.y < 0:
		activebody = $InteractBodyUp
		
	
		




func _physics_process(delta):
	get_input()
	move_and_slide()
	
	
	
	
func _process(delta):
	if Input.is_key_pressed(KEY_B):
		var game_manager = get_node("%GameManager")
		game_manager.switch_to_battle()
	if Input.is_action_just_pressed("Interact"):
		print(activebody)
