extends Node

var network = NetworkedMultiplayerENet.new()
var port = 1909
var max_players = 100

func _ready():
	change_window_settings()
	start_server()

func change_window_settings():
	VisualServer.render_loop_enabled = false
	OS.set_window_minimized(true)

func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")

func _peer_connected(pid):
	print("User " + str(pid) + " Connected")

func _peer_disconnected(pid):
	print("User " + str(pid) + " Disconnected")
