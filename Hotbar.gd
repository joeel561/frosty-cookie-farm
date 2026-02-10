class_name Hotbar extends Control

@export var inventory_data: InventoryData
@export var hotbar_size: int = 9
@export var hotbar_start_index: int = 0 

var selected_index: int = 0 
const SLOT_SCENE := preload("res://Resources/Slot.tscn")

func _ready() -> void:
	inventory_data.update.connect(update_hotbar)
	build_hotbar()
	update_hotbar()
	
func build_hotbar() -> void:
	for c in %HotbarSlots.get_children():
		c.queue_free()
		
	for i in range(hotbar_size):
		var inv_index := hotbar_start_index + i
		var slot_ui: Slot = SLOT_SCENE.instantiate()
		
		slot_ui.slot_index = inv_index
		slot_ui.set_slot(inventory_data.slots[inv_index])
		%HotbarSlots.add_child(slot_ui)
		
func update_hotbar() -> void: 
	for i in range(%HotbarSlots.get_child_count()):
		var inv_index := hotbar_start_index + i 
		var slot_ui: Slot = %HotbarSlots.get_child(i)
		slot_ui.slot_index = inv_index
		
		slot_ui.set_slot(inventory_data.slots[inv_index])
		
	update_selection_visual()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hotbar_next"):
		selected_index = (selected_index + 1) % hotbar_size
		update_selection_visual()

	if event.is_action_pressed("hotbar_prev"):
		selected_index = (selected_index - 1 + hotbar_size) % hotbar_size
		update_selection_visual()

	for i in range(hotbar_size):
		if event.is_action_pressed("hotbar_%d" % (i + 1)):
			selected_index = i
			update_selection_visual()
			break

	if event.is_action_pressed("use_item"):
		use_selected()

func update_selection_visual() -> void:
	for i in range(%HotbarSlots.get_child_count()):
		var slot_ui: Slot = %HotbarSlots.get_child(i)
		slot_ui.set_selected(i == selected_index)
		
		
func use_selected() -> void:
	var inv_index := hotbar_start_index + selected_index
	var slot := inventory_data.slots[inv_index]

	if slot.item == null or slot.amount <= 0:
		return

	if slot.item.item_name == "FlowerPurpleSeed":
		GlobalSignals.plantSelected = 1
	elif slot.item.item_name == "FlowerWhiteSeed":
		GlobalSignals.plantSelected = 2
