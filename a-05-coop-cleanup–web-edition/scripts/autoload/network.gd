extends Node

signal lobby_updated(players, host_id)
signal room_code_updated(code)
signal game_started()

const MAX_PLAYERS := 5
const PORT := 8910

var peer: ENetMultiplayerPeer
var players := {}
var host_id := 0
var room_code := ""

# =========================
# HOST
# =========================
func host_game(nickname: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_PLAYERS)
	multiplayer.multiplayer_peer = peer

	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	host_id = multiplayer.get_unique_id()
	room_code = _generate_room_code()

	players.clear()
	players[host_id] = {
		"id": host_id,
		"name": nickname
	}

	emit_signal("room_code_updated", room_code)
	_sync_lobby()

# =========================
# CLIENT
# =========================
func join_game(ip: String, nickname: String):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer

	multiplayer.connected_to_server.connect(func ():
		_register_player.rpc_id(1, nickname)
	)

# =========================
# RPCs
# =========================
@rpc("authority")
func _register_player(nickname: String):
	var id := multiplayer.get_remote_sender_id()

	players[id] = {
		"id": id,
		"name": nickname
	}

	_sync_lobby()

@rpc("authority")
func _start_game():
	emit_signal("game_started")

# =========================
# HOST EVENTS
# =========================
func _on_peer_connected(id):
	print("Peer conectado:", id)

func _on_peer_disconnected(id):
	players.erase(id)
	_sync_lobby()

# =========================
# LOBBY SYNC
# =========================
func _sync_lobby():
	var players_array = _get_players_array()
	emit_signal("lobby_updated", players_array, host_id)
	rpc("_receive_lobby", players_array, host_id)

@rpc("any_peer")
func _receive_lobby(players_array: Array, host: int):
	host_id = host
	players.clear()

	for p in players_array:
		players[p.id] = p

	emit_signal("lobby_updated", players_array, host_id)

# =========================
# PUBLIC API
# =========================
func start_game():
	if multiplayer.get_unique_id() == host_id:
		rpc("_start_game")

func leave_room():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	players.clear()

# =========================
# UTILS
# =========================
func _get_players_array() -> Array:
	return players.values()

func _generate_room_code() -> String:
	var chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
	var code := ""
	for i in 4:
		code += chars[randi() % chars.length()]
	return code

func get_room_code() -> String:
	return room_code

func get_players() -> Array:
	return _get_players_array()

func get_host_id() -> int:
	return host_id

func get_local_ip() -> String:
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.") or ip.begins_with("10.") or ip.begins_with("172."):
			if not ip.begins_with("127.") and ":" not in ip:
				return ip
	return "IP não encontrado"
