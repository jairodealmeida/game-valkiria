#class_name Network
extends Node

var server = null
var client = null
var default_port = 55455
var connect_ip = "127.0.0.1"
var unique_id = -1  

var game = null

func _ready():
	multiplayer.peer_connected.connect(player_joined)
	multiplayer.peer_disconnected.connect(player_left)
	
func host_server():	
	server = ENetMultiplayerPeer.new()
	server.create_server(default_port)
	multiplayer.multiplayer_peer = server
	unique_id = server.get_unique_id()

func join_server():
	client = ENetMultiplayerPeer.new()
	client.create_client(connect_ip,default_port)
	multiplayer.multiplayer_peer = client
	unique_id = client.get_unique_id()
	
func player_joined(id):
	print(str(id) + " hopped on")
	if id != 1:
		game.create_player(id)
	
func player_left(id):
	print(str(id) + "hopped off")
