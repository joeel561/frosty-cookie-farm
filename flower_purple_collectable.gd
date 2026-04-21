extends StaticBody2D

var animation_player

func _ready():
	animation_player = get_node("AnimationPlayer") as AnimationPlayer
	dropItem()
	
func dropItem():
	animation_player.play("drop_item")
	await get_tree().create_timer(0.5).timeout
	animation_player.play("idle")
	await get_tree().create_timer(5.0).timeout
	animation_player.play("fade")
	await get_tree().create_timer(0.3).timeout
