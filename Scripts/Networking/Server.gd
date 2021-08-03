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
	rpc_config("fetch_level", MultiplayerAPI.RPC_MODE_MASTER)
	print("Server started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")

func _peer_connected(pid):
	print("User " + str(pid) + " Connected")

func _peer_disconnected(pid):
	print("User " + str(pid) + " Disconnected")

remote func fetch_level(level_name, requester):
	var pid = get_tree().get_rpc_sender_id()
	var pkg = $Levels.get_node(level_name).pack()
	rpc_id(pid, "retrieve_level", pkg, requester)
	print("Sending level " + pkg.level + " to player with id " + str(pid))

remote func send_level(level_name, pkg):
	var pid = get_tree().get_rpc_sender_id()
	var level = $Levels.get_node(level_name)
	level.unpack(pkg)
	rpc_id(pid, "level_sent", level_name)
	print("Unpacking level " + level_name + " received from player with id " + str(pid))
	print("Level State: " + str(pkg))
