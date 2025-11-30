extends CharacterBody2D

const SPEED = 150
const JUMP_VELOCITY = -400.0
const GRAVITY := 100

@onready var animated_sprite = $AnimatedSprite2D

var look_direction: Vector2 = Vector2.DOWN

func _physics_process(delta: float):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_top")
	
	if input_vector != Vector2.ZERO:
		look_direction = input_vector
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	velocity = input_vector.normalized() * SPEED
	
	move_and_slide()
	
	if velocity.length() > 0:
		animated_sprite.play("walk_" + get_direction_name())
	else:
		animated_sprite.play("idle_" + get_direction_name())
	

func get_direction_name() -> String:
	if look_direction.y < 0: return "up"
	if look_direction.y > 0: return "down"
	if look_direction.x < 0: return "left"
	if look_direction.x > 0: return "right"
	return "down" 
