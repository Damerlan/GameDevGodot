extends Node
class_name GameController
















func _on_card_clicked(card: Card):
	if not can_player_input:
		return
	
	if slscted_cards.has(card):
		return
	
	card.flip_up()
	selected_cards.append(card)
	
	if selected_cards.size() == 2:
		_check_pair()
