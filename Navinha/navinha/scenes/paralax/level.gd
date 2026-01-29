extends Node2D

@export var base_speed : float = 200.0

func _process(delta):
	$"09".scroll_offset.x -= base_speed * 0.05 * delta
	
	$"08".scroll_offset.x -= base_speed * 0.1 * delta
	$"07".scroll_offset.x -= base_speed * 0.2 * delta
	$"06".scroll_offset.x -= base_speed * 0.3 * delta
	$"05".scroll_offset.x -= base_speed * 0.4 * delta
	$"04".scroll_offset.x -= base_speed * 0.6 * delta
	$"03".scroll_offset.x -= base_speed * 0.8 * delta
	$"02".scroll_offset.x -= base_speed * 1.0 * delta
	$"01".scroll_offset.x -= base_speed * 1.2 * delta
	$"00".scroll_offset.x -= base_speed * 1.4 * delta
