extends MultiplayerSynchronizer

@onready var player = $".."

var input_direction 

func _ready():
	# Desativa o processamento para instâncias sem autoridade
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	input_direction = Input.get_axis("move_left", "move_right")
func _physics_process(delta):
	input_direction = Input.get_axis("move_left", "move_right")
	
	# Verifica se o jogador pressionou o botão de pulo
	if Input.is_action_just_pressed("jump"):
		rpc("jump")  # Chama o método remoto 'jump'

	# Verifica se o jogador pressionou o botão de ataque
	if Input.is_action_just_pressed("attack"):
		rpc("attack")  # Chama o método remoto 'attack'

@rpc("call_local")
func jump():
	if player:
		player.do_jump = true  # Marca que o jogador deve pular

@rpc("call_local")
func attack():
	if player:
		player.do_attack = true  # Marca que o jogador deve atacar
