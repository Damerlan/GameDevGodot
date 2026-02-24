extends Node

var music_player := AudioStreamPlayer.new()
var sfx_player := AudioStreamPlayer.new()

var music_atual: AudioStream = null


func _ready() -> void:
	add_child(music_player)
	add_child(sfx_player)



func play_music(stream: AudioStream):
	if stream == null:
		return
	if music_atual == stream:
		return
	
	music_atual = stream
	music_player.stream = stream
	music_player.play()
	

func stop_music():
	music_player.stop()
	music_atual = null
