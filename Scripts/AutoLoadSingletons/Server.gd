extends Node

signal connected

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1" # Loopback
#var ip = "192.168.0.143" # Laptop at home on WLAN
var port = 1909

func _ready():
	rpc_config("fetch_level", MultiplayerAPI.RPC_MODE_MASTER)
	connect_to_server()

func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_succeeded")

func _on_connection_failed():
	print("Failed to connect to server")

func _on_connection_succeeded():
	emit_signal("connected")
	print("Successfully connected to server")

func fetch_level(level_name, requester):
	rpc_id(1, "fetch_level", level_name, requester)

remote func retrieve_level(w_pkg, requester):
	instance_from_id(requester).load_level_from_package(w_pkg)
