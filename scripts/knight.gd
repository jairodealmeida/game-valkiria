extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var multiplayer_input = %MultiplayerInput

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
var do_jump = false
var do_attack = false
var _is_on_floor = true
var alive = true

@onready var username_label = $UserName
var username = ""

@export var player_id := 1:
	set(id):
		player_id = id
		#MultiplayerManager.set_multiplayer_authority(id)
		#%MultiplayerInput.set_multiplayer_authority(player_id)
func _enter_tree():
	%MultiplayerInput.set_multiplayer_authority(player_id)
			
func _ready():
	#if multiplayer.is_server():
	#	multiplayer_input.set_multiplayer_authority(player_id)

	if multiplayer.get_unique_id() == player_id:
		#%MultiplayerInput.set_multiplayer_authority(player_id)
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false
		
		
'''func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	_apply_animations(delta)
	move_and_slide()
	'''


func _apply_animations():

	# Flip the Sprite
	if direction && direction > 0:
		animated_sprite.flip_h = false
	elif direction && direction < 0:
		animated_sprite.flip_h = true

	# Play animations
	if _is_on_floor:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		#if do_jump:
		animated_sprite.play("jump")
		#if do_attack:
		#		animated_sprite.play("attack")	
				
		#		animated_sprite.animation_finished.connect(_on_attack_finished)
			
func _on_attack_finished():
	#if animated_sprite.animation == "attack":
	print("Ataque concluído!")
	do_attack = false
		#_apply_animations()  # Retorna para a animação correta (idle, run, etc.)
		
func _apply_movement_from_input(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if do_jump and is_on_floor():
		print("Player is jumpping!")
		velocity.y = JUMP_VELOCITY
		do_jump = false

	# Handle attack
	if do_attack:
		print("Player is attacking!")
		animated_sprite.play("attack")
		do_attack = false
		animated_sprite.animation_finished.connect(_on_attack_finished)

	# Get input direction
	direction = %MultiplayerInput.input_direction

	# Apply movement
	if direction:
		velocity.x = (direction * SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _physics_process(delta):
	if multiplayer.is_server():
		if not alive && is_on_floor():
			_set_alive()
		
		_is_on_floor = is_on_floor()
		_apply_movement_from_input(delta)
		
	if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
		_apply_animations()

func mark_dead():
	print("Mark player dead!")
	alive = false
	$CollisionShape2D.set_deferred("disabled", true)
	$RespawnTimer.start()

func _respawn():
	print("Respawned!")
	position = MultiplayerManager.respawn_point
	$CollisionShape2D.set_deferred("disabled", false)

func _set_alive():
	print("alive again!")
	alive = true
	Engine.time_scale = 1.0
