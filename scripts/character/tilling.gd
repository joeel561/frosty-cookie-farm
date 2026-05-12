extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D

var direction: Vector2

func _on_process(delta: float):
	pass
	
func _on_physics_process(_delta: float) -> void:
	pass
	
func _on_next_transition() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("tilling_up")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("tilling_right")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("tilling_left")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("tilling_down")
	else:
		animated_sprite_2d.play("tilling_down")
		

func _on_exit() -> void:
	animated_sprite_2d.stop()
