extends NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 100

var direction: Vector2

func on_process(delta: float):
	pass
	
func _on_physics_process(delta: float):
	direction = GameInputEvents.movement_input()
		
	if direction == Vector2.UP:
		animated_sprite_2d.play("walk_up")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.play("walk_right")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.play("walk_left")
	elif direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_down")
		
	if direction != Vector2.ZERO:
		player.player_direction = direction
		
	
	player.velocity = direction * speed
	player.move_and_slide()
	
	

func _on_next_transition() -> void:
	if !GameInputEvents.is_movement_input():
		transition.emit("Idle")

func enter():
	pass

func exit():
	pass
