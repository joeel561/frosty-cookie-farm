extends Area2D

var selected = false
var seedType = 1 #flowerPurple

func _ready():
	$AnimatedSprite2D.play("default")

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left"):
		GlobalSignals.plantSelected = seedType
		selected = true
	elif event.is_action_released("mouse_left"):
		selected = false

func _physics_process(delta: float) -> void:
	if selected: 
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
