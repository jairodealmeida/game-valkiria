extends Node2D

var player_scene = preload("res://game/players/player.tscn")
# @export var players = null
@onready var players: Node2D = $Players

func _ready() -> void:
	
	Network.game = self	
	
	create_player(Network.unique_id)
	
func create_player(id):
	var p = player_scene.instantiate()
	p.name = str(id)
	#p.global_position = Vector2(500,0)
	p.set_multiplayer_authority(id)
	players.add_child(p)
