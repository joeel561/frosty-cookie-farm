extends Area2D

var plant: int = GlobalSignals.plantSelected
var plantGrowing: bool = false
var plantGrown: bool = false 

var flowerPurpleItem: Resource = preload("res://flower_purple_collectable.tscn")
var flowerWhiteItem: Resource = preload("res://flower_purple_collectable.tscn")

@export var purple_item: ItemData
@export var white_item: ItemData

var player: CharacterBody2D = null

func _ready():
	player = get_node("../env/Player") as CharacterBody2D

func _physics_process(delta: float):
	if plantGrowing == false: 
		plant = GlobalSignals.plantSelected

func _on_area_entered(area: Area2D):
	if not plantGrowing: 
		if plant == 1:
			plantGrowing = true
			$plant.visible = true;
			$flowerPurpleTimer.start()
			$plant.play("flowerPurpleGrowing")
		if plant == 2: 
			plantGrowing = true
			$plant.visible = true;
			$flowerWhiteTimer.start()
			$plant.play("flowerWhiteGrowing")
		else: 
			print('plant is already growing here')

func _on_flower_purple_timer_timeout() -> void:
	var flowerPurple = $plant
	if flowerPurple.frame == 0:
		flowerPurple.frame = 1
		$flowerPurpleTimer.start()
	elif flowerPurple.frame == 1:
		flowerPurple.frame = 2
		$flowerPurpleTimer.start()
	elif flowerPurple.frame == 2:
		flowerPurple.frame = 3
		plantGrown = true

func _on_flower_white_timer_timeout() -> void:
	var flowerWhite = $plant
	if flowerWhite.frame == 0:
		flowerWhite.frame = 1
		$flowerWhiteTimer.start()
	elif flowerWhite.frame == 1:
		flowerWhite.frame = 2
		$flowerWhiteTimer.start()
	elif flowerWhite.frame == 2:
		flowerWhite.frame = 3
		plantGrown = true

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left"):
		if plantGrown && is_player_in_area(): 
			if plant == 1:
				GlobalSignals.numOfFlowerPurple += 1
				plantGrowing = false
				plantGrown = false
				$plant.play("none")
			if plant == 2:
				GlobalSignals.numOfFlowerWhite += 1
				plantGrowing = false
				plantGrown = false
				$plant.play("none")
			else:
				pass
				
			drop_item(plant)

func drop_item(plant: int) -> void:
	if plant == 1: 
		var flowerPurple_instance = flowerPurpleItem.instantiate()
		flowerPurple_instance.global_position = $Marker2D.global_position
		purple_item.item_name 
		player.collect(purple_item)
	
		get_parent().add_child(flowerPurple_instance)

		await get_tree().create_timer(3).timeout
	if plant == 2: 
		var flowerWhite_instance = flowerWhiteItem.instantiate()
		flowerWhite_instance.global_position = $Marker2D.global_position
		player.collect(purple_item)
	
		get_parent().add_child(flowerWhite_instance)

		await get_tree().create_timer(3).timeout

func is_player_in_area() -> bool:
	return player.position.distance_to(position) <= 40.0
