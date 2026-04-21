extends StaticBody2D

var plant = GlobalSignals.plantSelected
var plantGrowing = false
var plantGrown = false 
var player_in_area = false

var flowerPurpleItem = preload("res://flower_purple_collectable.tscn")
var flowerWhiteItem = preload("res://flower_purple_collectable.tscn")

@export var purple_item: ItemData
@export var white_item: ItemData
@export var bell: ItemData
@export var flowerSeedPurple1: ItemData
@export var flowerSeedWhite1: ItemData
@export var gift_green: ItemData

var player = null

func _physics_process(delta: float) -> void:
	if plantGrowing == false: 
		plant = GlobalSignals.plantSelected

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not plantGrowing: 
		if plant == 1:
			plantGrowing = true
			$flowerPurpleTimer.start()
			$plant.play("flowerPurpleGrowing")
		if plant == 2: 
			plantGrowing = true
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


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("mouse_left"):
		if plantGrown && player_in_area: 
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
		
func drop_item(plant: int):
	if plant == 1: 
		var flowerPurple_instance = flowerPurpleItem.instantiate()
		flowerPurple_instance.global_position = $Marker2D.global_position
		player.collect(purple_item)
		player.collect(bell)
		player.collect(flowerSeedPurple1)
		player.collect(gift_green)
		player.collect(flowerSeedWhite1)
	
		get_parent().add_child(flowerPurple_instance)

		await get_tree().create_timer(3).timeout
	if plant == 2: 
		var flowerWhite_instance = flowerWhiteItem.instantiate()
		flowerWhite_instance.global_position = $Marker2D.global_position
		player.collect(purple_item)
	
		get_parent().add_child(flowerWhite_instance)

		await get_tree().create_timer(3).timeout


func _on_pick_up_body_entered(body: Node2D) -> void:
	print(body.is_in_group("player"))
	if body.is_in_group("player"):
		player_in_area = true
		player = body
		

func _on_pick_up_body_exited(body: Node2D) -> void:
	player_in_area = false
	player = null
