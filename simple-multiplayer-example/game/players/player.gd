extends CharacterBody2D

@export var movespeed = 300
@export var jumpheight = 600
@export var gravity = 400

func _ready():
	pass
	
func _process(delta: float):
	
	if !is_multiplayer_authority(): return
	
	velocity.x = 0
	if Input.is_action_pressed("left"):
		velocity.x = -movespeed
	if Input.is_action_pressed("right"):
		velocity.x = movespeed
	if is_on_floor():
		velocity.y = 1
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jumpheight
	else:
		velocity.y += gravity*delta
	move_and_slide()
	
	
"""const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
"""
